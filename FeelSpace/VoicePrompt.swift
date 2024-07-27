//
//  VoicePrompt.swift
//  FeelSpace
//
//  Created by Suryateja Duvvuri on 6/20/24.
//

import SwiftUI
import Foundation
import AVFoundation
import Speech


struct AudioOutput: Decodable
{
    var type: String
    var data: String?
}

struct Wave: Shape
{
    var frequency: Double
    var strength: Double
    var phaseShift: Double
    
    var animatableData: Double
    {
        get {phaseShift}
        set {self.phaseShift = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()
        
        let width = Double(rect.width)
        let height = Double(rect.height)
        let midWidth = width/2
        let midHeight = height/2
        let wavelen = width/frequency
        
        path.move(to: CGPoint(x: 0, y: midHeight))
        
        for x in stride(from: 0, through:width+10, by: 1)
        {
            let relX = x/wavelen
            let sine = sin(relX + phaseShift)
            let y = strength * sine + midHeight
            
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        return Path(path.cgPath)
    }
    

}

struct ResponsePage: View {
    @State private var phase = 0.0
    var body: some View {
        Spacer()
        Spacer()
        VStack
        {
            Wave(frequency: 50, strength: 30, phaseShift: phase).stroke(Color.white, lineWidth: 5).onAppear{
                withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: false))
                {
                    self.phase = .pi * 2
                }
            }
        }
        NavigationLink(destination: PostSurvey())
        {
            Text("Continue").padding(.all, 15).font(.title2).foregroundStyle(.black).background(RoundedRectangle(cornerRadius: 25.0).foregroundStyle(.white))
        }.navigationBarBackButtonHidden(true)
        
        Spacer()
        Spacer()
    }
}

struct VoicePrompt: View {
    
    @State private var okayed: Bool = false
    @State private var recorder: AVAudioRecorder!
    let recordingSession = AVAudioSession.sharedInstance()
    @State private var player: AVAudioPlayer!
    @State private var audioWrap: AudioOutput!
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining = 61
    @State private var overSixty = true
    @State private var done = false
    
    var body: some View {
        
        NavigationLink(destination: ResponsePage(), isActive: $done)
        {
            VStack
            {
                Spacer()
                Spacer()
                ZStack
                {
                    
                    Circle().fill(Color.clear).frame(width: 250, height: 250).overlay(
                       Circle().stroke(Color.white, lineWidth: 15)
                    )
                    Text(overSixty ? "1:00" : "\(timeRemaining)") .font(Font.system(size: 76, weight: .heavy))
                        .onReceive(timer, perform: { _ in
                        if timeRemaining == 60
                        {
                            timeRemaining -= 1
                            overSixty = false
                            startRecord()
                        }
                        else
                        {
                            if timeRemaining > 0
                            {
                                timeRemaining -= 1
                                if timeRemaining == 0
                                {
                                    done = true
                                    stopRecord()
                                }
                            }
                            
                            
                        }
                    })
                   
                    Spacer()
                    Spacer()
                }.disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                
                
                
                ZStack
                {
                    
                    VStack
                    {
                        Spacer()
                        Spacer()
                        ZStack
                        {
                            Circle().fill(.red).frame(width: 80, height: 80)
                            
                            Image(systemName: "mic.fill").foregroundColor(.white)
                                .font(.system(size: 25))
                        }
                        .offset(y:-70)
                        .onTapGesture {
                            if timeRemaining < 60
                            {
                                startRecord()
                            }
                            else if timeRemaining == 0
                            {
                                stopRecord()
                                
                            }
                            
                        }
                        
                    }
                    
                    
                }
                Spacer()
                Spacer()
            }
            
        }.navigationTitle("Voice Recorder")
    }
    
    func requestPermission() async {
        
        if await AVAudioApplication.requestRecordPermission(){
            okayed = true
            do
            {
                try setupAudio()
            }
             catch
             {
                 print(error)
             }
        }
        else
        {
            okayed = false
            print("Please go to privacy and settings page to change your permission")
        }
        
    }
    
    func setupAudio() throws
    {
       do
       {
           try recordingSession.setCategory(.playAndRecord, mode: .voiceChat)
           try recordingSession.setActive(true, options: .notifyOthersOnDeactivation)
       }
        catch
        {
            print(error)
        }
        try! setupRecord()
        
    }
    
    func setupRecord() throws
    {
        let audioSettings = [AVFormatIDKey: kAudioFormatMPEG4AAC, AVSampleRateKey: 12000, AVNumberOfChannelsKey:1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue] as [String : Any]
        
        let filePath = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)[0]
        let date =  DateFormatter()
        date.dateStyle = .medium
        let audioName = filePath.appendingPathComponent("recording.m4a")
        print(filePath)
        do
        {
            recorder = try AVAudioRecorder(url: audioName, settings: audioSettings)
            recorder.prepareToRecord()
        }
        catch
        {
            print(error)
        }
    }
    
    func startRecord()
    {
        print("Recording started")
        try! setupAudio()
        recorder.record()
    }
    
    func stopRecord()
    {
        print("Recording stopped")
        recorder.stop()
        let play = AVAudioSession.sharedInstance()
        do
        {
            try play.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        }
        catch
        {
            print("Unable to play")
        }
        
        
        
        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioName = filePath.appendingPathComponent("recording.m4a")
//        player = try! AVAudioPlayer(contentsOf: audioName)
//        player.prepareToPlay()
//        player.play()
        do
        {
            let data = try NSData(contentsOf: audioName, options: NSData.ReadingOptions.mappedIfSafe)
            let baseCode = data.base64EncodedString()
            let webSocket = sendHume(audioName:baseCode)
            
            receiveAudio(webSocketTask: webSocket)
            receiveAudio(webSocketTask: webSocket)
            receiveAudio(webSocketTask: webSocket)
            receiveAudio(webSocketTask: webSocket)
            receiveAudio(webSocketTask: webSocket)
            receiveAudio(webSocketTask: webSocket)
            receiveAudio(webSocketTask: webSocket)
            receiveAudio(webSocketTask: webSocket)
            receiveAudio(webSocketTask: webSocket)
            receiveAudio(webSocketTask: webSocket)
            receiveAudio(webSocketTask: webSocket)
            receiveAudio(webSocketTask: webSocket)
            receiveAudio(webSocketTask: webSocket)
        }
        catch
        {
            print(error)
        }
        
       
    }
    
    func sendHume(audioName:String) -> URLSessionWebSocketTask
    {
        let url = URL(string: "wss://api.hume.ai/v0/evi/chat?api_key=LGJ8kPC9JSpdzmkWxzUcwQx5pGSflyGpLObEuvzLyUjlUdtg")!
        let webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask.resume()
        
        //Convert the audio to a base64 and use that data to send it over.
        let dat = #"{"data": "\#(audioName)","type": "audio_input"}"#
        let datTwo = #"{"type": "user_input","text": "How can I make my day better or what can i do better from now on?"}"#
        let messageObj = URLSessionWebSocketTask.Message.string(dat)
        let endingMsg = URLSessionWebSocketTask.Message.string(datTwo)
        webSocketTask.send(messageObj) {
            error in
            if let error = error {
                print(error)
                print("Message did not send")
            }
        }
        webSocketTask.send(endingMsg) {
            error in
            if let error = error {
                print(error)
                print("Message did not send")
            }
        }
        
       return webSocketTask
    }
    
    func receiveAudio(webSocketTask: URLSessionWebSocketTask)
    {
        webSocketTask.receive
        {
            result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    print("Received data: \(data)")
                case .string(let text):
                   
                    do
                    {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        
                        audioWrap = try decoder.decode(AudioOutput.self, from: Data(text.utf8))
                        if(audioWrap.data == nil)
                        {
                            print("Pass\n")
                        }
                        else
                        {
//                            print(audioWrap.data!)
                            let base64 = audioWrap.data!
                            let dat = Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
                            if (dat != nil)
                            {
                                let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                                let file = filePath.appendingPathComponent("output.m4a")
                                do
                                {
                                    try dat?.write(to: file, options: .atomic)
                                    do
                                    {
                                        player = try AVAudioPlayer(contentsOf: file)
                                        player.prepareToPlay()
                                        player.play()
                                    }
                                    catch
                                    {
                                        print(error)
                                    }
                                }
                                catch
                                {
                                    print(error)
                                }
                            }
                            
                            
                            
                            
                            
                        }
                         
                       
                    }
                    catch
                    {
                        print(error)
                    }
                   
                @unknown default:
                    fatalError()
                }
                
            case .failure(_):
                print("Error")
            }
        }
    }
    
    
}

#Preview {
    VoicePrompt()
}
