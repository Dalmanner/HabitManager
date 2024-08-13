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
    @Published var habits: [Habit] = [] {
        didSet {
            print("Habits updated in ViewModel: \(habits.count)")
        }
    }

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
                
                // Debugging logs
                print("Habits updated: \(self.habits.map { $0.title })")
            }
    }

    func addHabit(_ habit: Habit, completion: @escaping (Bool) -> Void) {
        do {
            _ = try db.collection("habits").addDocument(from: habit) { error in
                if let error = error {
                    print("Error adding habit: \(error.localizedDescription)")
                    completion(false)
                } else {
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
        } catch {
            print("Error updating habit: \(error.localizedDescription)")
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
}

