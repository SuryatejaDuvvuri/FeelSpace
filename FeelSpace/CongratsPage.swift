//
//  CongratsPage.swift
//  SwiftUIAPICalls
//
//  Created by Suryateja Duvvuri on 6/26/24.
//

import SwiftUI

struct CongratsPage: View {
    var body: some View {
        Text("Congratulations!")
        Text("You have bravely finished your session!")
        
        
        NavigationLink
        {
            FeedPage()
        } label: {
            Text("Continue")
        }
        
    }
}

#Preview {
    CongratsPage()
}
