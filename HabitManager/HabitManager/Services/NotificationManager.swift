//
//  NotificationManager.swift
//  HabitManager
//
//  Created by Mac on 2024-08-13.
//

import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    @Published var notificationAccessGranted: Bool = false

    init() {
        requestNotificationAccess()
    }

    func requestNotificationAccess() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error requesting notification access: \(error.localizedDescription)")
                }
                self?.notificationAccessGranted = granted
                print("Notification access granted: \(granted)")
            }
        }
    }

    func scheduleNotification(for habit: Habit) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Habit Reminder"
        notificationContent.body = habit.reminderText
        notificationContent.sound = UNNotificationSound.default

        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: habit.reminderDate)

        for day in habit.weekdays {
            guard let weekday = calendar.weekdaySymbols.firstIndex(of: day) else { continue }

            var dateComponents = DateComponents()
            dateComponents.hour = components.hour
            dateComponents.minute = components.minute
            dateComponents.weekday = weekday + 1  // Weekday index starts at 1 (Sunday)

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let request = UNNotificationRequest(
                identifier: "\(habit.id ?? UUID().uuidString)_\(day)",
                content: notificationContent,
                trigger: trigger
            )

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled for \(habit.title) on \(day)")
                }
            }
        }
    }
}

