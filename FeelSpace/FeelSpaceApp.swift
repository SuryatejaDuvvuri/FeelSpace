//
//  FeelSpaceApp.swift
//  FeelSpace
//
//  Created by Suryateja Duvvuri on 6/28/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}



@main
struct FeelSpaceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            LoginPage()
        }
    }
}

