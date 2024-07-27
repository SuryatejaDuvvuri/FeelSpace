//
//  LoginPage.swift
//  FeelSpace
//
//  Created by Suryateja Duvvuri on 7/27/24.
//

import SwiftUI
import UIKit
import FirebaseCore
import FirebaseAuth
//import GoogleSignInSwift
//import GoogleSignIn


struct LoginPage: View {
    
    @State private var isSigned = false
    @State private var email = ""
    @State private var password = ""
    
    
    var body: some View
    {
       
        NavigationView
        {
            if !isSigned
            {
                VStack
                {
                    Text("Login")
                    TextField(text: $email, label: {
                        Text("Email Address").foregroundStyle(.white)
                    }).padding().background(RoundedRectangle(cornerRadius: 50.0).stroke(style: /*@START_MENU_TOKEN@*/StrokeStyle()/*@END_MENU_TOKEN@*/).foregroundStyle(.white))
                        .keyboardType(.emailAddress)
                    SecureField(text: $password, label: {
                        Text("Password").foregroundStyle(.white)
                    }).padding().background(RoundedRectangle(cornerRadius: 50.0).stroke(style: /*@START_MENU_TOKEN@*/StrokeStyle()/*@END_MENU_TOKEN@*/).foregroundStyle(.white))
                    
                    Button{
                        if signIn()
                        {
//                            if signUp()
//                            {
//                                isSigned = true
//                            }
                        }
                    }label: {
                       HStack
                        {
                            Spacer()
                            Text("Login").foregroundStyle(.white).padding().background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)).foregroundColor(.gray)
                            Spacer()
                        }.padding()
                    }
                    
                    
                }.padding().navigationTitle("Login")
            }
            else
            {
                ContentView()
            }
            
        }
            .navigationViewStyle(StackNavigationViewStyle())
        
       
        
    }
    
    func signIn() -> Bool
    {
        Auth.auth().signIn(withEmail: email, password: password)
        {
            result, error in
            
            if let error = error
            {
                print("failed to login")
                isSigned = false
                
            }
            else
            {
                print("successfully logged in")
                isSigned = true
                
            }
            
        }
        
        return isSigned
    }
    
    func signUp() -> Bool
    {
        Auth.auth().createUser(withEmail: email, password: password){
            result, error in
            if let error = error
            {
                print("failed to sign up")
                isSigned = false
            }
            else
            {
                print("success")
                print("user uid: \(result?.user.uid ?? "Failed to retrieve")")
                isSigned = true
            }
        }
        
        return isSigned
    }
}


#Preview {
    LoginPage()
}


