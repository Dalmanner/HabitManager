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
    @State private var selectedHabitIndex: Int? = nil

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
                            ForEach(viewModel.habits.indices, id: \.self) { index in
                                HabitCardView(habit: $viewModel.habits[index], viewModel: viewModel)
                                    .onTapGesture {
                                        selectedHabitIndex = index
                                        showEditHabitView.toggle()
                                    }
                                    .onDelete {
                                        viewModel.deleteHabit(viewModel.habits[index])
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    }
                }

                Spacer()

                Button(action: {
                    selectedHabitIndex = nil
                    showEditHabitView.toggle()
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
                if let index = selectedHabitIndex {
                    let bindingHabit = $viewModel.habits[index]
                    EditHabitView(viewModel: viewModel, habit: bindingHabit)
                } else {
                    AddHabitView(viewModel: viewModel)
                }
            }
        }
    }
}



