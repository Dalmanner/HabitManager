//
//  HabitListView.swift
//  HabitManager
//
//  Created by Mac on 2024-06-20.
//

import SwiftUI

struct HabitListView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject private var viewModel = HabitViewModel()
    @State private var showAddHabitView = false

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.habits.isEmpty {
                    Text("No habits yet!")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.habits) { habit in
                            NavigationLink(destination: EditHabitView(habit: habit, viewModel: viewModel)) {
                                HabitRowView(habit: habit)
                            }
                        }
                        .onDelete(perform: deleteHabit) // Enable swipe-to-delete
                    }
                }

                Spacer()

                Button(action: {
                    showAddHabitView = true
                }) {
                    Text("Add New Habit")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 24)
                }
                .padding()
            }
            .navigationTitle("My Habits")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Sign Out") {
                        appViewModel.signOut()
                    }
                }
            }
            .sheet(isPresented: $showAddHabitView) {
                AddHabitView(viewModel: viewModel)
            }
        }
    }
    
    private func deleteHabit(at offsets: IndexSet) {
        offsets.forEach { index in
            let habit = viewModel.habits[index]
            viewModel.deleteHabit(habit)
        }
    }
}
