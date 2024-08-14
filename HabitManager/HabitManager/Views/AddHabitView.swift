//
//  AddHabitView.swift
//  HabitManager
//
//  Created by Mac on 2024-06-20.
//

import SwiftUI
import FirebaseAuth
import UserNotifications

struct AddHabitView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: HabitViewModel
    @State private var title = ""
    @State private var habitColor = "Card-1"
    @State private var weekdays: [String] = []
    @State private var isReminderOn = false
    @State private var reminderText = ""
    @State private var reminderDate = Date()
    @State private var showTimePicker = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {

                // MARK: TextField - Title
                TextField("Title", text: $title)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color(.secondarySystemBackground).opacity(0.4), in: RoundedRectangle(cornerRadius: 6, style: .continuous))

                // MARK: Habit Color Picker
                HStack(spacing: 0) {
                    ForEach(1...7, id: \.self) { index in
                        let color = "Card-\(index)"
                        Circle()
                            .fill(Color(color))
                            .frame(width: 30, height: 30)
                            .overlay {
                                if color == habitColor {
                                    Image(systemName: "checkmark")
                                        .font(.caption.bold())
                                        .foregroundColor(.white)
                                        .shadow(color: .black, radius: 0.5, x: 0.5, y: 0.5)
                                }
                            }
                            .onTapGesture {
                                withAnimation {
                                    habitColor = color
                                }
                            }
                    }
                }
                .padding(.vertical)

                Divider()

                // MARK: Frequency Selection (weekdays)
                VStack(alignment: .leading, spacing: 6) {
                    Text("Frequency")
                    HStack(spacing: 10) {
                        let weekdaysSymbols = Calendar.current.weekdaySymbols
                        ForEach(weekdaysSymbols, id: \.self) { day in
                            let index = weekdays.firstIndex(where: { $0 == day })
                            Text(day.prefix(3))
                                .font(.callout)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 3)
                                .background {
                                    let color = index == nil ? Color(.secondarySystemBackground) : Color(habitColor)
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(color.opacity(0.4))
                                }
                                .onTapGesture {
                                    withAnimation {
                                        if let index = index {
                                            weekdays.remove(at: index)
                                        } else {
                                            weekdays.append(day)
                                        }
                                    }
                                }
                        }
                    }
                    .padding(.vertical, 15)
                }
                .padding(.vertical, 10)

                if isReminderOn {
                    Divider()

                    // MARK: Reminder Toggle
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Reminder")
                                .fontWeight(.semibold)

                            Text("Just notification")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Toggle(isOn: $isReminderOn, label: {})
                            .labelsHidden()
                    }

                    // MARK: Reminder Date and TextField
                    HStack(spacing: 12) {
                        Label {
                            Text(reminderDate.formatted(date: .omitted, time: .shortened))
                        } icon: {
                            Image(systemName: "clock")
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        .background {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color(.secondarySystemBackground).opacity(0.4))
                        }
                        .onTapGesture {
                            withAnimation {
                                showTimePicker.toggle()
                            }
                        }

                        TextField("Reminder Text...", text: $reminderText)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color(.secondarySystemBackground).opacity(0.4))
                            }
                    }
                    .animation(.easeInOut, value: isReminderOn)
                    .frame(height: isReminderOn ? nil : 0)
                    .opacity(isReminderOn ? 1 : 0)
                }

            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Add New Habit")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        let userId = Auth.auth().currentUser?.uid ?? "unknown_user"
                        let newHabit = Habit(
                            id: nil,
                            title: title,
                            color: habitColor,
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
            }
            .overlay {
                if showTimePicker {
                    ZStack {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    showTimePicker.toggle()
                                }
                            }

                        DatePicker("", selection: $reminderDate, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.secondarySystemBackground))
                            }
                            .padding()
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
