//
//  EditHabitView.swift
//  HabitManager
//
//  Created by Mac on 2024-08-13.
//

import SwiftUI
import UserNotifications

struct EditHabitView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: HabitViewModel
    @State private var habit: Habit

    init(habit: Habit, viewModel: HabitViewModel) {
        _habit = State(initialValue: habit)
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Habit Details")) {
                    TextField("Title", text: $habit.title)
                    ColorPicker("Color", selection: Binding(get: {
                        Color(habit.color)
                    }, set: { newColor in
                        habit.color = "\(newColor)"
                    }))
                    Toggle("Reminder", isOn: $habit.isReminderOn)
                    if habit.isReminderOn {
                        DatePicker("Reminder Time", selection: $habit.reminderDate, displayedComponents: .hourAndMinute)
                        TextField("Reminder Text", text: $habit.reminderText)
                    }
                    MultiSelectPicker(title: "Weekdays", options: Calendar.current.weekdaySymbols, selections: $habit.weekdays)
                }

                Button("Save Changes") {
                    habit.dateUpdated = Date()
                    viewModel.updateHabit(habit)
                    dismiss()
                }
                .disabled(habit.title.isEmpty)
            }
            .navigationTitle("Edit Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
