//
//  AddHabitView.swift
//  HabitManager
//
//  Created by Mac on 2024-06-20.
//

import SwiftUI
import FirebaseAuth

struct AddHabitView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: HabitViewModel
    @State private var title = ""
    @State private var color = ""
    @State private var weekdays: [String] = []
    @State private var isReminderOn = false
    @State private var reminderText = ""
    @State private var reminderDate = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Habit Details")) {
                    TextField("Title", text: $title)

                    // Custom Color Picker
                    HStack(spacing: 20) {
                        ForEach(habitColors, id: \.self) { colorName in
                            Circle()
                                .fill(Color.fromString(colorName))
                                .frame(width: 30, height: 30)
                                .overlay {
                                    if color == colorName {
                                        Image(systemName: "checkmark")
                                            .font(.caption.bold())
                                            .foregroundColor(.white)
                                            .shadow(color: .black, radius: 0.5, x: 0.5, y: 0.5)
                                    }
                                }
                                .onTapGesture {
                                    withAnimation {
                                        color = colorName
                                    }
                                }
                        }
                    }
                    .padding(.vertical)

                    // Reminder Toggle
                    Toggle("Reminder", isOn: $isReminderOn)
                    if isReminderOn {
                        DatePicker("Reminder Time", selection: $reminderDate, displayedComponents: .hourAndMinute)
                        TextField("Reminder Text", text: $reminderText)
                    }
                    MultiSelectPicker(title: "Weekdays", options: Calendar.current.weekdaySymbols, selections: $weekdays)
                }

                Button("Add Habit") {
                    let userId = Auth.auth().currentUser?.uid ?? "unknown_user"
                    let newHabit = Habit(
                        id: nil,
                        title: title,
                        color: color,
                        weekdays: weekdays,
                        isReminderOn: isReminderOn,
                        reminderText: reminderText,
                        reminderDate: reminderDate,
                        userId: userId,
                        dateCreated: Date(),
                        dateUpdated: Date()
                    )
                    viewModel.addHabit(newHabit) { success in
                        if success {
                            dismiss()
                        }
                    }
                }
                .disabled(title.isEmpty)
            }
            .navigationTitle("Add New Habit")
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
