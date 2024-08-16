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
        HabitRowView(habit: Habit.init(title: "Drink Water", color: "Card-1", weekdays: ["Monday", "Tuesday"], isReminderOn: true, reminderText: "Drink water every 2 hours", reminderDate: Date(), userId: "123", dateCreated: Date(), dateUpdated: Date(), completedDates: [Date()], streak: 2))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

