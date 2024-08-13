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
    @State private var color = "Card-1"
    @State private var weekdays: [String] = []
    @State private var isReminderOn = false
    @State private var reminderText = ""
    @State private var reminderDate = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Habit Details")) {
                    TextField("Title", text: $title)
                    ColorPicker("Color", selection: Binding(get: {
                        Color(color)
                    }, set: { newColor in
                        color = "\(newColor)"
                    }))
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

struct MultiSelectPicker: View {
    let title: String
    let options: [String]
    @Binding var selections: [String]

    var body: some View {
        Section(header: Text(title)) {
            ForEach(options, id: \.self) { option in
                MultiSelectRow(option: option, isSelected: selections.contains(option)) {
                    if selections.contains(option) {
                        selections.removeAll { $0 == option }
                    } else {
                        selections.append(option)
                    }
                }
            }
        }
    }
}

struct MultiSelectRow: View {
    let option: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(option)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                }
            }
        }
        .foregroundColor(.primary)
    }
}

//preview:
struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView(viewModel: HabitViewModel())
    }
}
