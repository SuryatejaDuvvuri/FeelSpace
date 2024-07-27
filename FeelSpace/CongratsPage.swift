//
//  CongratsPage.swift
//  SwiftUIAPICalls
//
//  Created by Suryateja Duvvuri on 6/26/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct CongratsPage: View {
    var body: some View {
        
        VStack
        {
            ZStack
            {
                Circle().fill(Color.clear).frame(width: 250, height: 250).overlay(
                   Circle().stroke(Color.white, lineWidth: 15)
                )
                Image(systemName: "checkmark").font(Font.system(size: 76, weight: .heavy)).foregroundColor(Color.green)
            }
            
            Text("Congratulations!")
            Text("You have bravely finished your session!")
            
            NavigationLink
            {
                FeedPage()
            } label: {
                Text("Continue")
            }
            
        }.navigationBarBackButtonHidden()
       
        
    }
}

#Preview {
    CongratsPage().preferredColorScheme(.dark)
}

