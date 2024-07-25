//
//  Habit.swift
//  HabitManager
//
//  Created by Mac on 2024-06-20.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Habit: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var description: String
    var goal: Int
    var current: Int
    var completed: Bool
    var date: Date
    var userId: String
    var streak: Int
}
