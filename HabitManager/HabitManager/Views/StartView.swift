//
//  StartView.swift
//  HabitManager
//
//  Created by Mac on 2024-06-20.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                TopBar()
                Spacer().frame(height: 20)
                NavigationStack {
                    VStack {
                        
                        Text("Welcome to")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Habit Manager!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom, 20)
                        
                        Text("Create an account or sign in to get started")
                            .padding()
                        
                        HStack {
                            NavigationLink(destination: LoginView(appViewModel: appViewModel)) {
                                Text("Sign In")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.black)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            
                            NavigationLink(destination: CreateAccountView().environmentObject(appViewModel)) {
                                Text("Create Account")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.black)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
    }
}

extension View {
    func dismissKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

// Preview:
struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .environmentObject(AppViewModel())
    }
}
