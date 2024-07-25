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
    static let shared = FirebaseService()
    
    private let db = Firestore.firestore()
    
    func fetchHabits() -> AnyPublisher<[Habit], Error> {
        return Future<[Habit], Error> { promise in
            self.db.collection("habits").addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    do {
                        let habits = try querySnapshot?.documents.compactMap { document -> Habit? in
                            try document.data(as: Habit.self)
                        } ?? []
                        promise(.success(habits))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func addHabit(_ habit: Habit) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            do {
                _ = try self.db.collection("habits").addDocument(from: habit) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func updateHabit(_ habit: Habit) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            do {
                guard let id = habit.id else {
                    promise(.failure(FirebaseError.missingDocumentID))
                    return
                }
                _ = try self.db.collection("habits").document(id).setData(from: habit) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func deleteHabit(_ habit: Habit) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            do {
                guard let id = habit.id else {
                    promise(.failure(FirebaseError.missingDocumentID))
                    return
                }
                self.db.collection("habits").document(id).delete { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}
            


