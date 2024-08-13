//
//  UserViewModel.swift
//  HabitManager
//
//  Created by Mac on 2024-08-12.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import SwiftUI

@MainActor
class UserViewModel: ObservableObject {
    var auth = Auth.auth()
    private var db = Firestore.firestore()
    @Published var user: User?
    
    func signUp(email: String, password: String, displayName: String, completion: @escaping (Bool) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                completion(false)
            } else if let result = result {
                self.user = User(id: result.user.uid, name: displayName, email: email)
                self.saveUserToFirestore(user: self.user!) { success in
                    completion(success)
                }
            } else {
                completion(false)
            }
        }
    }

    private func saveUserToFirestore(user: User, completion: @escaping (Bool) -> Void) {
        do {
            try db.collection("users").document(user.id!).setData(from: user) { error in
                if let error = error {
                    print("Error saving user to Firestore: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        } catch let error {
            print("Error encoding user for Firestore: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error logging in: \(error.localizedDescription)")
                completion(false)
            } else if let result = result {
                self.fetchUser(userId: result.user.uid)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func fetchUser(userId: String) {
        let user = db.collection("users").document(userId)
        user.getDocument { document, error in
            if let error = error {
                print("Error getting user: \(error.localizedDescription)")
            } else if let document = document, document.exists {
                self.user = try? document.data(as: User.self)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
            self.user = nil
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
