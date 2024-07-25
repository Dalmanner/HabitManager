//
//  HabitManagerApp.swift
//  HabitManager
//
//  Created by Mac on 2024-06-17.
//

import SwiftUI

@main
struct HabitManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            StartView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
