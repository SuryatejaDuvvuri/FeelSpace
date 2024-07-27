//
//  PostSurvey.swift
//  FeelSpace
//
//  Created by Suryateja Duvvuri on 6/26/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore



struct PostSurvey: View {
    
    var questions: [String] = ["How do you feel?", "Was this helpful?", "Would you be open to post this anonymously?"]
    var options: [[String]] = [["Good", "Okay", "Bad"], ["Yes", "No"], ["Yes", "No"]]
    @State private var changeQuestion = false
    @State private var question: Int = 0
    var body: some View {
        Text("Post Survey").font(.largeTitle).multilineTextAlignment(.center).padding()
        VStack(alignment: .leading, spacing: 6)
        {
            Spacer()
            Spacer()

            
            
            
            ForEach(questions.indices) {
                question in
                Text("\(questions[question])").font(.title3)
                ForEach(options[question].indices) {
                    option in
                    NavigationLink
                    {
                        CongratsPage()
                    } label:
                    {
                        Text("\(options[question][option])").padding(.all, 15).font(.title2).foregroundStyle(.black).background(RoundedRectangle(cornerRadius: 25.0).foregroundStyle(.white))
                    }
                   
                }
               
            }
            Spacer()
            Spacer()
            
            
            
            
            HStack(alignment: .center)
            {
                ForEach(0..<questions.count, id: \.self) {
                    question in
                    Circle().frame(width: 10, height: 30).foregroundColor(.white)
                }
            }
              
    
        }
    }
}

#Preview {
    PostSurvey()
}
