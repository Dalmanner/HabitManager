//
//  HabitViewModel.swift
//  HabitManager
//
//  Created by Mac on 2024-06-20.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

final class HabitViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var selectedHabit: Habit?

    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?

    init() {
        fetchHabits()
    }

    deinit {
        listener?.remove()
    }

    func fetchHabits() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        listener = db.collection("habits")
            .whereField("userId", isEqualTo: userId)
            .order(by: "dateCreated", descending: true)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching habits: \(error.localizedDescription)")
                    return
                }
                
                self.habits = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Habit.self)
                } ?? []
            }
    }

    func addHabit(_ habit: Habit, completion: @escaping (Bool) -> Void) {
            do {
                _ = try db.collection("habits").addDocument(from: habit) { error in
                    if let error = error {
                        print("Error adding habit: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        // Schedule notification after habit is added successfully
                        if habit.isReminderOn {
                            self.scheduleNotification(for: habit)
                        }
                        completion(true)
                    }
                }
            } catch {
                print("Error encoding habit: \(error.localizedDescription)")
                completion(false)
            }
        }

        func updateHabit(_ habit: Habit) {
            guard let habitId = habit.id else { return }
            do {
                try db.collection("habits").document(habitId).setData(from: habit)
                // Reschedule notification after habit is updated
                if habit.isReminderOn {
                    self.scheduleNotification(for: habit)
                }
            } catch {
                print("Error updating habit: \(error.localizedDescription)")
            }
        }

        private func scheduleNotification(for habit: Habit) {
            let content = UNMutableNotificationContent()
            content.title = habit.title
            content.body = habit.reminderText
            content.sound = UNNotificationSound.default

            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: habit.reminderDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let request = UNNotificationRequest(identifier: habit.id ?? UUID().uuidString, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                }
            }
        }

    func deleteHabit(_ habit: Habit) {
        guard let habitId = habit.id else { return }
        db.collection("habits").document(habitId).delete { error in
            if let error = error {
                print("Error deleting habit: \(error.localizedDescription)")
            }
        }
    }

    func markHabitAsDone(_ habit: inout Habit) {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let lastCompletedDate = habit.lastCompletedDate {
            let difference = Calendar.current.dateComponents([.day], from: lastCompletedDate, to: today).day ?? 0

            if difference == 1 {
                habit.streak += 1
            } else if difference > 1 {
                habit.streak = 1 // Reset the streak
            }
        } else {
            habit.streak = 1 // Start the streak
        }

        habit.lastCompletedDate = today
        habit.completedDates.append(today)

        updateHabit(habit)
    }

    func selectHabitForEditing(_ habit: Habit) {
        self.selectedHabit = habit
    }
}
