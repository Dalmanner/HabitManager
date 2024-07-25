//
//  AppDelegate.swift
//  HabitManager
//
//  Created by Mac on 2024-07-25.
//

import UIKit
import Firebase

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

