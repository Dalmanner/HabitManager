//
//  LoginView.swift
//  HabitManager
//
//  Created by Mac on 2024-06-20.
//

import Foundation
import SwiftUI
import Firebase

struct LoginView: View {
    
    @State var signedIn = false
    
    @State private var email = ""
    @State private var password = ""
    @State private var error = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State private var showingSheet = false
    @State private var sheetType = ""
    
    var body: some View {
        VStack {
            Text("Habit Manager")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            TextField("Email", text: $email)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            Button(action: {
                Auth.auth().signIn(withEmail: self.email, password: self.password) { (result, error) in
                    if error != nil {
                        self.error = error!.localizedDescription
                        self.alertMessage = self.error
                        self.alertTitle = "Error"
                        self.showingAlert = true
                    } else {
                        self.sheetType = "home"
                        self.showingSheet = true
                    }
                }
            }) {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.blue)
                    .cornerRadius(15.0)
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented: $showingSheet) {
                if self.sheetType == "home" {
                    HomeView()
                }
            }
        }
        .padding()
    }
}
