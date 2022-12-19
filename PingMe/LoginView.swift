//
//  LoginView.swift
//  PingMe
//
//  Created by Ali Bagherinia on 12/10/22.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: ViewModel

    @State var userName: String = ""
    @State var passWord: String = ""
    @State var rePassWord: String = ""

    var body: some View {
        switch viewModel.authState {
        case .WillSignUp:
            VStack {
                TextField("Email", text: $userName)
                TextField("Password", text: $passWord)
                TextField("Retype Password", text: $rePassWord)

                Button("Sign-up") {
                    viewModel.authState = .WillSignUp
                    viewModel.signUp(userName: userName, passWord: passWord)
                }.background(.yellow)

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
                TextField("Email", text: $userName)
                TextField("Password", text: $passWord)

                Button("Sign-in") {
                    viewModel.authState = .WillSignIn
                }.background(.yellow)

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
