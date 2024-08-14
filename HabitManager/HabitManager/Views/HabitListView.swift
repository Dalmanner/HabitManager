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
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(viewModel.habits) { habit in
                                HabitCardView(habit: Binding.constant(habit)) {
                                    deleteHabit(habit: habit)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
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
    
    private func deleteHabit(habit: Habit) {
        viewModel.deleteHabit(habit)
    }
}


