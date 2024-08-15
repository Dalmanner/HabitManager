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

                    // Custom Color Picker
                    HStack(spacing: 20) {
                        ForEach(habitColors, id: \.self) { colorName in
                            Circle()
                                .fill(Color.fromString(colorName))
                                .frame(width: 30, height: 30)
                                .overlay {
                                    if habit.color == colorName {
                                        Image(systemName: "checkmark")
                                            .font(.caption.bold())
                                            .foregroundColor(.white)
                                            .shadow(color: .black, radius: 0.5, x: 0.5, y: 0.5)
                                    }
                                }
                                .onTapGesture {
                                    withAnimation {
                                        habit.color = colorName
                                    }
                                }
                        }
                    }
                    .padding(.vertical)

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

let habitColors: [String] = [
    "Card-1", "Card-2", "Card-3", "Card-4", "Card-5", "Card-6", "Card-7"
]

extension Color {
    static func fromString(_ string: String) -> Color {
        return Color(string)
    }
}



