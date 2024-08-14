//
//  AppViewModel.swift
//  HabitManager
//
//  Created by Mac on 2024-08-13.
//

import SwiftUI
import FirebaseAuth

final class AppViewModel: ObservableObject {
    @Published var isSignedIn: Bool = false
    @Published var notificationManager: NotificationManager = NotificationManager()
    private var authListener: AuthStateDidChangeListenerHandle?

    init() {
        authListener = Auth.auth().addStateDidChangeListener { _, user in
            self.isSignedIn = user != nil
        }
    }

    deinit {
        if let authListener = authListener {
            Auth.auth().removeStateDidChangeListener(authListener)
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            isSignedIn = false
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}


