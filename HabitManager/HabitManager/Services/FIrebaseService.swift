//
//  FIrebaseService.swift
//  HabitManager
//
//  Created by Mac on 2024-06-20.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class FirebaseService {
    let db = Firestore.firestore()
    
    func createHabit(habit: Habit) {
        do {
            let _ = try db.collection("habits").addDocument(from: habit)
        } catch {
            print("There was an error while trying to save a habit: \(error.localizedDescription)")
        }
    }
    
    func fetchHabits(userId: String) -> AnyPublisher<[Habit], Error> {
        return Future<[Habit], Error> { promise in
            let habits = self.db.collection("habits").whereField("userId", isEqualTo: userId)
            habits.addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    let habits = querySnapshot?.documents.compactMap { document -> Habit? in
                        try? document.data(as: Habit.self)
                    } ?? []
                    promise(.success(habits))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func updateHabit(habit: Habit) {
        if let habitId = habit.id {
            do {
                try db.collection("habits").document(habitId).setData(from: habit)
            } catch {
                print("There was an error while trying to update a habit: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteHabit(habit: Habit) {
        if let habitId = habit.id {
            db.collection("habits").document(habitId).delete { error in
                if let error = error {
                    print("There was an error while trying to delete a habit: \(error.localizedDescription)")
                }
            }
        }
    }
}

            


