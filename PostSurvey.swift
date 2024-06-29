//
//  PostSurvey.swift
//  SwiftUIAPICalls
//
//  Created by Suryateja Duvvuri on 6/26/24.
//

import SwiftUI

struct PostSurvey: View {
    
    var questions: [String] = ["How do you feel?", "Was this helpful?", "Would you be open to post this anonymously?"]
    var options: [[String]] = [["Good", "Okay", "Bad"], ["Yes", "No"], ["Yes", "No"]]
    var body: some View {
        VStack
        {
            Text("Post Survey").font(.largeTitle).multilineTextAlignment(.center).padding()
            List(questions.indices) {
                question in
                Text("\(questions[question])").font(.title3)
//                Text("\(question)")
                
                ForEach(options[question].indices) {
                    option in
                    NavigationLink
                    {
                        CongratsPage()
                    } label:
                    {
                        Text("\(options[question][option])")
                    }
                   
                }
                
                    
                
            }
           
           
            
          
        }
    
       
    }
}

#Preview {
    PostSurvey()
}
