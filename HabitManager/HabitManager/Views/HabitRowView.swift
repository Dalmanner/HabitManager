//
//  HabitRowView.swift
//  HabitManager
//
//  Created by Mac on 2024-08-13.
//

import SwiftUI

struct HabitRowView: View {
    let habit: Habit

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(habit.title)
                    .font(.headline)
                if !habit.reminderText.isEmpty {
                    Text(habit.reminderText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            if habit.isReminderOn {
                Image(systemName: "bell.fill")
                    .foregroundColor(.yellow)
            }
            Circle()
                .fill(Color(habit.color))
                .frame(width: 20, height: 20)
        }
        .padding(.vertical, 8)
    }
}

struct HabitRowView_Previews: PreviewProvider {
    static var previews: some View {
        HabitRowView(habit: Habit(
            id: "sampleId",
            title: "Sample Habit",
            color: "",
            weekdays: ["Monday", "Wednesday", "Friday"],
            isReminderOn: true,
            reminderText: "Remember to do this!",
            reminderDate: Date(),
            userId: "sampleUserId",
            dateCreated: Date(),
            dateUpdated: Date()
        ))
        .previewLayout(.sizeThatFits)
    }
}

