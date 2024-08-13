//
//  LoginView.swift
//  HabitManager
//
//  Created by Mac on 2024-06-20.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var loginError = ""
    @State private var isLoading = false
    @ObservedObject var appViewModel: AppViewModel

    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                TextField("Email address", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .disableAutocorrection(true)
                
                passwordField
                
                HStack {
                    Spacer()
                    Button("Forgot password?") {
                        resetPassword()
                    }
                    .foregroundColor(.gray)
                }
                
                if isLoading {
                    ProgressView()
                        .padding()
                } else {
                    Button("Enter", action: signIn)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                if !loginError.isEmpty {
                    Text(loginError)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .padding()
        .dismissKeyboardOnTap()
        .navigationTitle("Sign In")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var passwordField: some View {
        ZStack {
            if showPassword {
                TextField("Password", text: $password)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .disableAutocorrection(true)
            } else {
                SecureField("Password", text: $password)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .disableAutocorrection(true)
            }
            HStack {
                Spacer()
                Button(action: {
                    self.showPassword.toggle()
                }) {
                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                }
            }
        }
    }
    
    private func signIn() {
        guard !email.isEmpty && !password.isEmpty else {
            loginError = "Please enter email and password."
            return
        }
        
        isLoading = true
        loginError = ""
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            isLoading = false
            if let error = error {
                loginError = "Failed to sign in: \(error.localizedDescription)"
                return
            }
            // Successfully signed in
            appViewModel.isSignedIn = true
        }
    }
    
    private func resetPassword() {
        guard !email.isEmpty else {
            loginError = "Please enter your email address."
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                loginError = error.localizedDescription
            } else {
                loginError = "Reset password link sent to your email."
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LoginView(appViewModel: AppViewModel())
        }
    }
}

