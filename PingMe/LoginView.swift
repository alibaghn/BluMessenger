//
//  LoginView.swift
//  PingMe
//
//  Created by Ali Bagherinia on 12/10/22.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var email: String = ""
    @State var password: String = ""
    @State var rePassword: String = ""
    @State var passwordMatchError = false
    let passwordMatchDescription = "Passwords do not match"

    var body: some View {
        switch viewModel.authState {
        case .WillSignUp:
            Color(#colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1)).ignoresSafeArea().overlay {
                VStack {
                    CustomTextField(title: "Email", text: email)
                    CustomTextField(title: "Password", text: password)
                    CustomTextField(title: "Retype Password", text: rePassword)

                    CustomButton(closure: {
                        viewModel.authState = .WillSignUp
                        signUp()
                    }, text: "Sign Up", tintColor: .accentColor)
                        .alert(passwordMatchDescription, isPresented: $passwordMatchError, actions: {})
                        .alert(viewModel.signUpErrorDescription, isPresented: $viewModel.signUpError) {}

                    CustomButton(closure: {
                        viewModel.authState = .WillSignIn

                    }, text: "Sign In", tintColor: .gray)
                }
                .padding()
                .onAppear {
                    print("Here it is!")
                    viewModel.fetchUsers()
                    viewModel.addAuthListener()
                }
            }

        case .WillSignIn, .DidSignOut:
            Color(#colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1)).ignoresSafeArea().overlay {
                VStack {
                    CustomTextField(title: "Email", text: email)
                    CustomTextField(title: "Password", text: password)

                    CustomButton(closure: {
                        viewModel.authState = .WillSignIn
                        signIn()
                    }, text: "Sign In", tintColor: .accentColor)
                        .alert(viewModel.signInErrorDescription, isPresented: $viewModel.signInError) {}

                    CustomButton(closure: {
                        viewModel.authState = .WillSignUp
                    }, text: "Sign Up", tintColor: .gray)
                }
                .padding()
                .onAppear {
                    viewModel.addAuthListener()
                }
            }

        case .DidSignIn:
            UsersView().transition(.move(edge: .leading))
        }
    }
}

// MARK: - Functions

extension LoginView {
    func signUp() {
        guard !password.isEmpty, !rePassword.isEmpty else {
            return
        }
        guard password == rePassword else {
            passwordMatchError = true
            return
        }
        viewModel.signUp(email: email, password: password)
    }

    func signIn() {
        guard password.isEmpty else { return }
        viewModel.signIn(email: email, password: password)
    }
}
