//
//  User.swift
//  HabitManager
//
//  Created by Mac on 2024-08-12.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var email: String
    // Removed password to prevent storing sensitive data in Firestore
}

