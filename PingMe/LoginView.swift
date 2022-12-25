//
//  LoginView.swift
//  PingMe
//
//  Created by Ali Bagherinia on 12/10/22.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        switch viewModel.authState {
        case .WillSignUp:
            Color(#colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1)).ignoresSafeArea().overlay {
                VStack {
                    CustomTextField(title: "Email", text: $viewModel.email)
                    CustomTextField(title: "Password", text: $viewModel.password)
                    CustomTextField(title: "Retype Password", text: $viewModel.rePassword)

                    CustomButton(closure: {
                        viewModel.authState = .WillSignUp
                        viewModel.signUp()
                    }, text: "Sign Up", tintColor: .accentColor)
                    .alert(viewModel.passwordMatchDescription, isPresented: $viewModel.passwordMatchError, actions: {})
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
                    CustomTextField(title: "Email", text: $viewModel.email)
                    CustomTextField(title: "Password", text: $viewModel.password)

                    CustomButton(closure: {
                        viewModel.authState = .WillSignIn
                        viewModel.signIn()
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

