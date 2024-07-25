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

    var body: some View {
        VStack {
            Spacer()
            
            Text("Sign in")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            VStack(spacing: 16) {
                TextField("Email address", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                ZStack {
                    if showPassword {
                        TextField("Password", text: $password)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                    } else {
                        SecureField("Password", text: $password)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            self.showPassword.toggle()
                        }) {
                            Image(systemName: self.showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                }

                HStack {
                    Spacer()
                    Button(action: {
                        // Forgot password action
                    }) {
                        Text("Forgot password?")
                            .foregroundColor(.gray)
                    }
                }

                Button(action: {
                    signIn()
                }) {
                    Text("Enter")
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
    }
    
    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.loginError = error.localizedDescription
                return
            }
            // Successful sign-in actions
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}



