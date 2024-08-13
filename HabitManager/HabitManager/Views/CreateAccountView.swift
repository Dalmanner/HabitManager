//
//  CreateAccountView.swift
//  HabitManager
//
//  Created by Mac on 2024-08-12.
//

import SwiftUI
import FirebaseAuth

struct CreateAccountView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    // Other state properties
    @State private var email = ""
    @State private var password = ""
    @State private var displayName = ""
    @State private var errorMessage = ""
    @State private var isLoading = false

    var body: some View {
        VStack {
            Spacer()
            
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextField("Display Name", text: $displayName)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

            if isLoading {
                ProgressView()
            } else {
                Button("Create Account") {
                    createAccount()
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Spacer()
        }
        .padding()
    }

    private func createAccount() {
        isLoading = true
        // Implement your create account logic here
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            isLoading = false
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                // Successfully created account
                appViewModel.isSignedIn = true
            }
        }
    }
}

// Preview
struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
            .environmentObject(AppViewModel())
    }
}

