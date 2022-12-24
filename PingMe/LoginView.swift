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

    var body: some View {
        switch viewModel.authState {
        case .WillSignUp:
            VStack {
                TextField("Email", text: $email)
                TextField("Password", text: $password)
                TextField("Retype Password", text: $rePassword)

                Button("Sign-up") {
                    viewModel.authState = .WillSignUp
                    signUp()

                }.background(.yellow)
                    .alert(passwordMatchDescription, isPresented: $passwordMatchError, actions: {})
                    .alert(viewModel.signUpErrorDescription, isPresented: $viewModel.signUpError) {}

                Button("Sign-in") {
                    viewModel.authState = .WillSignIn
                }
            }
            .padding()
            .onAppear {
                print("Here it is!")
                viewModel.fetchUsers()
                viewModel.addAuthListener()
            }

        case .WillSignIn, .DidSignOut:
            VStack {
                TextField("Email", text: $email)
                TextField("Password", text: $password)

                Button("Sign-in") {
                    viewModel.authState = .WillSignIn
                    viewModel.signIn(email: email, password: password)

                }.background(.yellow)

                    .alert(viewModel.signInErrorDescription, isPresented: $viewModel.signInError) {}

                Button("Sign-up") {
                    viewModel.authState = .WillSignUp
                }
            }
            .padding()
            .onAppear {
                viewModel.addAuthListener()
            }

        case .DidSignIn:
            UsersView().transition(.move(edge: .leading))
        }
    }
}

// struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView().environmentObject(ViewModel())
//    }
// }
