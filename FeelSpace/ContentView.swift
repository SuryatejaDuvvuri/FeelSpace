//
//  ContentView.swift
//  FeelSpace
//
//  Created by Suryateja Duvvuri on 5/20/24.
//

import SwiftUI
import UIKit
import FirebaseCore


struct ContentView: View {
    
    var textSelected = false
    var voiceSelected = false
    
    var body: some View
    {
        VStack
        {
            Text("Choose one of the following options").font(.title)
            NavigationLink(destination: CountdownPage(isText: !textSelected, isVoice: voiceSelected)){
                
          
                Text("Text").padding(.all, 15).font(.title2).foregroundStyle(.black).background(RoundedRectangle(cornerRadius: 25.0).foregroundStyle(.white))
               
            }
            
            NavigationLink
            {
                CountdownPage(isText: textSelected, isVoice: !voiceSelected)
            } label :
            {
                Text("Voice").padding(.all, 15).font(.title2).foregroundStyle(.black).background(RoundedRectangle(cornerRadius: 25.0).foregroundStyle(.white))
            }
            
            
        }
        .navigationTitle("FeelSpace")
    }
}

struct CountdownPage: View {
    
    var isText: Bool
    var isVoice: Bool
    @State private var timeRemaining : Int = 5
    @State private var changeColor = false
    @State private var switchView = false
    @State private var actualView: any View = VoicePrompt()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
    
        if isText
        {
            NavigationLink(destination: TextPrompt(), isActive: $switchView)
            {
                Text("\(timeRemaining)")
                       .onReceive(timer) { _ in
                           if timeRemaining > 1 {
                               timeRemaining -= 1
                               changeColor = !changeColor
                           }
                           else if timeRemaining == 0
                           {
                               Text("GO!") .font(Font.system(size: 96, weight: .heavy))
                                   .foregroundStyle(
                                       LinearGradient(colors: [.white, changeColor ?.red : .blue], startPoint: .top, endPoint: .bottom)
                                   )
                                   .animation(.easeInOut, value: Color.accentColor)
                               timeRemaining -= 1
                           }
                           else
                           {
                               switchView = true
                           }
                       }
                       .font(Font.system(size: 96, weight: .heavy))
                       .foregroundStyle(
                           LinearGradient(colors: [.white, changeColor ?.red : .blue], startPoint: .top, endPoint: .bottom)
                       )
                       .animation(.easeInOut, value: Color.accentColor)
            }.navigationBarBackButtonHidden()
               
        }
        else
        {
            NavigationLink(destination: VoicePrompt(), isActive: $switchView)
            {
                Text("\(timeRemaining)")
                       .onReceive(timer) { _ in
                           if timeRemaining > 0 {
                               timeRemaining -= 1
                               changeColor = !changeColor
                           }
                           else
                           {
                               switchView = true
                           }
                       }
                       .font(Font.system(size: 96, weight: .heavy))
                       .foregroundStyle(
                           LinearGradient(colors: [.white, changeColor ?.red : .blue], startPoint: .top, endPoint: .bottom)
                       )
                       .animation(.easeInOut, value: Color.accentColor)
            }.navigationBarBackButtonHidden()
               
        }
       
        
       
    }
}


#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
