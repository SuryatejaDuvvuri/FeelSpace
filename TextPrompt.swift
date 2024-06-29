//
//  TextPrompt.swift
//  SwiftUIAPICalls
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

struct TextPrompt: View {
     @State private var user : [Response]?
     @State private var stuff : String = ""
     
     var body: some View {
        
         VStack{
             TextField("Enter your message", text: $stuff)
             Button(action: {connectHume(stuff:stuff)}, label: {
                 Text("Connect")
             })
         }
         NavigationLink(destination: PostSurvey()) {
             Text("Continue")
         }
         
     }
     
     func connectHume(stuff:String)
     {
         let url = URL(string: "wss://api.hume.ai/v0/evi/chat?api_key=LGJ8kPC9JSpdzmkWxzUcwQx5pGSflyGpLObEuvzLyUjlUdtg")!
         let webSocketTask = URLSession.shared.webSocketTask(with: url)
         webSocketTask.resume()
         
         let dat = #"{"type": "user_input","text": "\#(stuff)"}"#
         let messageObj = URLSessionWebSocketTask.Message.string(dat)
         webSocketTask.send(messageObj) {
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
                             print(msg.models.prosody.scores["Admiration"]!)
                             // function call to give the emotion based on the highest score
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
    TextPrompt()
}
