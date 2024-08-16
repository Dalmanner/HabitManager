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
    @State private var showEditHabitView = false
    @State private var selectedHabit: Habit?

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
                            HabitCardView(habit: habit)
                                .onTapGesture {
                                    selectedHabit = habit
                                    showEditHabitView = true
                                }
                        }
                        .onDelete(perform: deleteHabit)
                    }
                    .listStyle(PlainListStyle())
                }

                Spacer()

                Button(action: {
                    selectedHabit = nil
                    showEditHabitView = true
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
            .sheet(isPresented: $showEditHabitView) {
                if let selectedHabit = selectedHabit {
                    EditHabitView(viewModel: viewModel, habit: Binding(
                        get: { selectedHabit },
                        set: { newValue in
                            self.selectedHabit = newValue
                        }
                    ))
                } else {
                    AddHabitView(viewModel: viewModel)
                }
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




