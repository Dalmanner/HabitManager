//
//  Habit.swift
//  HabitManager
//
//  Created by Mac on 2024-06-20.
//

import Foundation
import FirebaseFirestoreSwift

struct Habit: Codable, Identifiable, Equatable {
    @DocumentID var id: String?
    var title: String
    var color: String
    var weekdays: [String]  // Days the habit should be completed
    var isReminderOn: Bool
    var reminderText: String
    var reminderDate: Date
    var userId: String
    var dateCreated: Date
    var dateUpdated: Date
    var completedDates: [Date] // Track completion dates
    var streak: Int // Track the current streak
    var lastCompletedDate: Date? // Track the last completion date
}



