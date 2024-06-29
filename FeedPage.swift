//
//  FeedPage.swift
//  SwiftUIAPICalls
//
//  Created by Suryateja Duvvuri on 6/26/24.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct Post : Decodable
{
    var title:String
    var paragraph:String
}

struct FeedPage: View {
    let databaseURL = ""
    var body: some View {
       
        NavigationLink
        {
            PostPage()
        } label: {
            Text("Post 1") .font(.largeTitle)
                .padding()
                .foregroundStyle(.black)
                .background(.white)
                .clipShape(.capsule)
                .navigationTitle("Posts")
        }
        
    }
}

#Preview {
    FeedPage()
}
