//
//  StartView.swift
//  HabitManager
//
//  Created by Mac on 2024-06-20.
//

import SwiftUI


struct StartView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("Keep track!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            
            Text("Manage your habits easily!")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 20)
            
            VStack(spacing: 16) {
                Button(action: {
                    // Action for sign in
                    
                }) {
                    Text("Sign In")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    // Action for create account
                }) {
                    Text("Create account")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 2)
                        )
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}




