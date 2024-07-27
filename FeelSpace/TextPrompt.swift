//
//  TextPrompt.swift
//  FeelSpace
//
//  Created by Suryateja Duvvuri on 6/20/24.
//

import SwiftUI

struct Response: Decodable
{
    var message: [String:String]
    var models: Models
}

struct Prosody: Decodable {
    var scores: [String: Double] // Assuming scores is a dictionary with String keys and Double values
}

struct Models: Decodable {
    var prosody: Prosody
}



@MainActor class WebSocket: ObservableObject
{
    @Published var messages = [String]()
    
    init()
    {
        connectHume(stuff:"")
    }
    func connectHume(stuff:String)
    {
        if (stuff != "")
        {
            let url = URL(string: "wss://api.hume.ai/v0/evi/chat?api_key=")!
            let webSocketTask = URLSession.shared.webSocketTask(with: url)
            webSocketTask.resume()
            
            let dat = #"{"type": "user_input","text": "\#(stuff)"}"#
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
            recieveMessage(webSocketTask: webSocketTask)
            recieveMessage(webSocketTask: webSocketTask)
            recieveMessage(webSocketTask: webSocketTask)
            recieveMessage(webSocketTask: webSocketTask)
            recieveMessage(webSocketTask: webSocketTask)
            recieveMessage(webSocketTask: webSocketTask)
            recieveMessage(webSocketTask: webSocketTask)
        }
        
        
    }
    
    func recieveMessage(webSocketTask:URLSessionWebSocketTask)
    {
        webSocketTask.receive {
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
                        let msg = try decoder.decode(Response.self, from: Data(text.utf8))
                        // function call to give the emotion based on the highest score
                        if msg.message["role"] == "user" && msg.models.prosody.scores["Admiration"] == nil
                        {
                            print("Pass by")
                        }
                        else
                        {
                            print(msg.message["content"] ?? "Pass by")
//                             print(msg.models.prosody.scores["Admiration"]!)
                            // function call to give the emotion based on the highest score
                        }
                       
                        DispatchQueue.main.async {
                            self.messages.append(msg.message["content"]  ?? "")
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


struct TextResponsePage: View {
    @State private var phase = 0.0
    let submittedText: String
    @ObservedObject var Socket = WebSocket()
    
    var body: some View {
//        Spacer()
//        Spacer()
//        VStack
//        {
//            Wave(frequency: 50, strength: 30, phaseShift: phase).stroke(Color.white, lineWidth: 5)
//                .onAppear{
//                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false))
//                {
//                    self.phase = .pi * 2
//                }
//            }
//        }
        
        VStack {
            ForEach(Socket.messages, id: \.self) { msg in
                Text("\(msg)")
            }
           
            
            NavigationLink(destination: PostSurvey())
            {
                Text("Continue").padding(.all, 15).font(.title2).foregroundStyle(.black).background(RoundedRectangle(cornerRadius: 25.0).foregroundStyle(.white))
            }.navigationBarBackButtonHidden(true)
            
        }.onAppear(perform: {
            Socket.connectHume(stuff: submittedText)
        })
       
        Spacer()
        Spacer()
    }
}

struct TextPrompt: View {
     @State private var user : [Response]?
     @State private var stuff : String = ""
     let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
     @State private var timeRemaining = 60
     @State private var overSixty = true
     @State private var done = false
     
     var body: some View {
         
         
         NavigationLink(destination: TextResponsePage(submittedText: stuff), isActive: $done) {
             VStack{
                 Spacer()
                 ZStack
                 {
                     
                     Circle().fill(Color.clear).frame(width: 250, height: 250).overlay(
                        Circle().stroke(Color.white, lineWidth: 15)
                     )
                     Text(overSixty ? "1:00" : "0:\(timeRemaining)") .font(Font.system(size: 76, weight: .heavy))
                         .onReceive(timer, perform: { _ in
                         if timeRemaining == 60
                         {
                             timeRemaining -= 1
                             overSixty = false
                         }
                         else
                         {
                             if timeRemaining > 0
                             {
                                 timeRemaining -= 1
                                 if timeRemaining == 0
                                 {
                                     done = true

                                 }
                             }
                             
                             
                         }
                     })
                     
                     
                     
                 }
                 Spacer()
                 
                
             }
             .padding()
         }.navigationBarBackButtonHidden()
         
         TextField("Enter your message", text: $stuff).textFieldStyle(RoundedBorderTextFieldStyle())
//         Button(action: {connectHume(stuff:stuff)}, label: {
//             Text("Connect")
//         })
//         NavigationLink(destination: PostSurvey()) {
//             Text("Continue")
//         }.navigationBarBackButtonHidden()
         
         
     }
}

#Preview {
    TextPrompt()
}
