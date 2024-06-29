//
//  ContentView.swift
//  SwiftUIAPICalls
//
//  Created by Suryateja Duvvuri on 5/20/24.
//

import SwiftUI



struct ContentView: View {
   
    var body: some View
    {
       NavigationView
        {
            VStack
            {
                NavigationLink {
                    TextPrompt()
                } label: {
                    Text("Text")
                }
                NavigationLink {
                    VoicePrompt()
                } label: {
                    Text("Voice")
                }
            }
            .navigationTitle("FeelSpace")
        }
    }
}


#Preview {
    ContentView()
}
