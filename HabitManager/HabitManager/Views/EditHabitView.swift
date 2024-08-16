//
//  EditHabitView.swift
//  HabitManager
//
//  Created by Mac on 2024-08-13.
//

import SwiftUI

struct EditHabitView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: HabitViewModel
    @Binding var habit: Habit

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Habit Details")) {
                    TextField("Title", text: $habit.title)

                    HStack(spacing: 20) {
                        ForEach(habitColors, id: \.self) { colorName in
                            Circle()
                                .fill(Color(colorName))
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
                                    habit.color = colorName
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

                Button("Perform Habit") {
                    viewModel.markHabitAsDone(&habit)
                    dismiss()
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)

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

private func scheduleNotification(for habit: Habit) {
    let content = UNMutableNotificationContent()
    content.title = habit.title
    content.body = habit.reminderText
    content.sound = UNNotificationSound.default

    let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: habit.reminderDate)
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

    let request = UNNotificationRequest(identifier: habit.id ?? UUID().uuidString, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request)
}


let habitColors: [String] = [
    "Card-1", "Card-2", "Card-3", "Card-4", "Card-5", "Card-6", "Card-7"
]

struct EditHabitView_Previews: PreviewProvider {
    static var previews: some View {
        EditHabitView(viewModel: HabitViewModel(), habit: .constant(Habit(title: "Exercise", color: "Card-1", weekdays: ["Monday", "Wednesday", "Friday"], isReminderOn: true, reminderText: "Remember to exercise!", reminderDate: Date(), userId: "123", dateCreated: Date(), dateUpdated: Date(), completedDates: [], streak: 0)))
    }
}

