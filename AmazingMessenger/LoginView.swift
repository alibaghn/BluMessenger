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
            K.bgColor.ignoresSafeArea().overlay {
                VStack {
                    CustomTextField(title: "Email", text: $viewModel.email)
                    CustomTextField(title: "Password", text: $viewModel.password)
                    CustomTextField(title: "Retype Password", text: $viewModel.rePassword)

                    CustomButton(closure: {
                        viewModel.signUp()
                    }, text: "Sign Up", tintColor: .blue)
                        .alert(viewModel.passwordMatchDescription, isPresented: $viewModel.passwordMatchError, actions: {})
                        .alert(viewModel.signUpErrorDescription, isPresented: $viewModel.signUpError) {}

                    CustomButton(closure: {
                        viewModel.authState = .WillSignIn

                    }, text: "Sign In", tintColor: .gray)
                }
                .padding()
                .onAppear {
                    viewModel.addAuthListener()
                }
            }

        case .WillSignIn, .DidSignOut:
            K.bgColor.ignoresSafeArea().overlay {
                VStack {
                    CustomTextField(title: "Email", text: $viewModel.email)
                    CustomTextField(title: "Password", text: $viewModel.password)

                    CustomButton(closure: {
                        print("pressed sign in")
                        viewModel.signIn()
                    }, text: "Sign In", tintColor: .blue)
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
