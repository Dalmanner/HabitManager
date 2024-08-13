//
//  HabitManagerApp.swift
//  HabitManager
//
//  Created by Mac on 2024-06-17.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct HabitManagerApp: App {
    @StateObject private var appViewModel = AppViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if appViewModel.isSignedIn {
                HabitListView()
                    .environmentObject(appViewModel)
            } else {
                StartView()
                    .environmentObject(appViewModel)
            }
        }
    }
}
