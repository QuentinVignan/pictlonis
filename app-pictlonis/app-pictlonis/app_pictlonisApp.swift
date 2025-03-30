//
//  app_pictlonisApp.swift
//  app-pictlonis
//
//  Created by Quentin Vignan on 05/11/2022.
//

import SwiftUI
import Firebase
import FirebaseFirestore

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        let settings = Firestore.firestore().settings
        settings.host = "localhost:8080"
        settings.isPersistenceEnabled = false
        settings.isSSLEnabled = false
        Firestore.firestore().settings = settings
        return true
    }
}


@main
struct app_pictlonisApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(PresentedView())
        }
    }
}
