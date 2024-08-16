//
//  HabitCardView.swift
//  HabitManager
//
//  Created by Mac on 2024-08-14.
//
import SwiftUI

struct HabitCardView: View {
    @Binding var habit: Habit
    @State private var isCompletedToday = false
    @ObservedObject var viewModel: HabitViewModel

    init(habit: Binding<Habit>, viewModel: HabitViewModel) {
        self._habit = habit
        self.viewModel = viewModel
        self._isCompletedToday = State(initialValue: habit.wrappedValue.completedDates.contains { Calendar.current.isDateInToday($0) })
    }

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text(habit.title)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                Spacer()

                VStack(alignment: .trailing) {
                    Text("Streak: \(habit.streak)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Button(action: toggleCompleted) {
                        Image(systemName: isCompletedToday ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(isCompletedToday ? .green : .gray)
                            .imageScale(.large)
                    }
                    .buttonStyle(BorderlessButtonStyle()) // Prevents interference with parent gestures
                }
            }
            .padding(.horizontal, 10)

            // Displaying Weekdays
            HStack {
                ForEach(habit.weekdays, id: \.self) { day in
                    Text(day.prefix(3)) // Display first three letters of each weekday
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(4)
                        .background(Color(habit.color).opacity(0.3))
                        .cornerRadius(4)
                }
            }
            .padding(.top, 10)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(habit.color))
                .opacity(0.35)
        )
        .padding(.horizontal)
        .frame(maxWidth: 600)
        .contentShape(Rectangle()) // Makes the entire card tappable
        .onTapGesture {
            print("Card tapped for habit: \(habit.title)")
            viewModel.selectHabitForEditing(habit)
        }
    }

    private func toggleCompleted() {
        if isCompletedToday {
            habit.completedDates.removeAll { Calendar.current.isDateInToday($0) }
            habit.streak = max(habit.streak - 1, 0)
        } else {
            viewModel.markHabitAsDone(&habit)
        }

        isCompletedToday.toggle()
    }
}


