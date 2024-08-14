//
//  HabitCardView.swift
//  HabitManager
//
//  Created by Mac on 2024-08-14.
//
import SwiftUI

struct HabitCardView: View {
    @Binding var habit: Habit
    @State private var editHabit = false
    let onDelete: () -> Void

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text(habit.title)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                if habit.isReminderOn {
                    Image(systemName: "bell.badge.fill")
                        .font(.callout)
                        .foregroundColor(Color(habit.color))
                        .scaleEffect(0.8)
                        .offset(x: -3, y: -3)
                        .shadow(color: .black, radius: 0.1, x: 0.1, y: -0.1)
                }

                Spacer()

                let count = habit.weekdays.count
                Text(count == 7 ? "Everyday" : "\(count) times a week")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 10)

            let activePlot = getActivePlot()

            HStack {
                ForEach(activePlot.indices, id: \.self) { index in
                    let item = activePlot[index]

                    VStack(spacing: 6) {
                        Text(item.dayName.prefix(3))
                            .font(.caption)
                            .foregroundColor(.gray)

                        let status = habit.weekdays.contains(item.dayName)

                        Text(formatDate(date: item.date))
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .shadow(color: Color(.systemBackground), radius: 0.4, x: 0.3, y: 0.3)
                            .padding(8)
                            .background {
                                Circle()
                                    .fill(Color(habit.color))
                                    .opacity(status ? 1 : 0)
                            }
                    }
                }
            }
            .padding(.top, 15)
        }
        .padding()
        .background(Color("TFBG").opacity(0.35), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .padding(.horizontal)
        .frame(maxWidth: 600)
        .onTapGesture {
            editHabit.toggle()
        }
        .sheet(isPresented: $editHabit) {
            EditHabitView(habit: habit, viewModel: HabitViewModel())
        }
        .modifier(Delete(action: onDelete))
    }

    private func getActivePlot() -> [(dayName: String, date: Date)] {
        let calendar = Calendar.current
        let currentWeek = calendar.dateInterval(of: .weekOfMonth, for: Date())
        let weekdaySymbols = calendar.weekdaySymbols
        let startDate = currentWeek?.start ?? Date()

        return weekdaySymbols.indices.compactMap { index -> (String, Date)? in
            guard let currentDate = calendar.date(byAdding: .day, value: index, to: startDate) else {
                return nil
            }
            return (weekdaySymbols[index], currentDate)
        }
    }

    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: date)
    }
}



