//
//  Habit.swift
//  HabitManager
//
//  Created by Mac on 2024-06-20.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct Habit: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var color: String
    var weekdays: [String]
    var isReminderOn: Bool
    var reminderText: String
    var reminderDate: Date
    var userId: String
    var dateCreated: Date
    var dateUpdated: Date
}

