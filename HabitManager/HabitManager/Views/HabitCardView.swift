//
//  HabitCardView.swift
//  HabitManager
//
//  Created by Mac on 2024-08-14.
//
import SwiftUI

struct HabitCardView: View {
    let habit: Habit

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text(habit.title)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                Spacer()

                if habit.isReminderOn {
                    Image(systemName: "bell.fill")
                        .foregroundColor(.yellow)
                        .imageScale(.medium)
                }

                Text("Streak: \(habit.streak)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 10)
            
            HStack(spacing: 8) {
                ForEach(habit.weekdays, id: \.self) { day in
                    Text(day.prefix(2))
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(4)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color(habit.color))
                                .opacity(0.7)
                        )
                }
            }
            .padding(.top, 5)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(habit.color))
                .opacity(0.35)
        )
        .padding(.horizontal)
        .frame(maxWidth: 600)
        .contentShape(Rectangle())
    }
}


//preview:
struct HabitCardView_Previews: PreviewProvider {
    static var previews: some View {
        HabitCardView(habit: Habit(title: "Drink Water", color: "Card-1", weekdays: ["Monday", "Tuesday", "Wednesday"], isReminderOn: true, reminderText: "", reminderDate: Date(), userId: "", dateCreated: Date(), dateUpdated: Date(), completedDates: [], streak: 0))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}







