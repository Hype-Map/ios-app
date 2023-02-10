//
//  Hype_MapApp.swift
//  Hype Map
//
//  Created by Артем Соловьев on 16.01.2023.
//

import SwiftUI
import Firebase

@main
struct Hype_MapApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        NetworkMonitor.shared.startMonitoring()
        return true
    }
}
