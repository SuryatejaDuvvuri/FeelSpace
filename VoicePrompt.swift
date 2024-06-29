//
//  VoicePrompt.swift
//  SwiftUIAPICalls
//
//  Created by Suryateja Duvvuri on 6/20/24.
//

import SwiftUI
import Foundation
import AVFoundation

struct AudioOutput: Decodable
{
    var type: String
    var data: String?
}

struct VoicePrompt: View {
    
    @State private var okayed: Bool = false
    @State private var recorder: AVAudioRecorder!
    let recordingSession = AVAudioSession.sharedInstance()
    @State private var count:Bool = false
    @State private var player: AVAudioPlayer!
    @State private var audioWrap: AudioOutput!
    
    var body: some View {
        
        NavigationView
        {
            ZStack
            {
                VStack
                {
                    Spacer()
                    
                    ZStack
                    {
                        Circle().fill(.red).frame(width: 80, height: 80)
                        
                        Image(systemName: "mic.fill").foregroundColor(.white)
                            .font(.system(size: 25))
                    }
                    .offset(y:-70)
                    .onTapGesture {
                        if count == false
                        {
                            startRecord()
                            count = true
                        }
                        else
                        {
                            stopRecord()
                            count = false
                        }
                   
                    }
                }
                
                
            }.navigationTitle("Voice Recorder")
        }
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
        player = try! AVAudioPlayer(contentsOf: audioName)
        player.prepareToPlay()
        player.play()
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
