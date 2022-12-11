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
        if viewModel.authState == .Signup {
            VStack {
                TextField("Username", text: $userName)
                TextField("Password", text: $passWord)
                TextField("Retype Password", text: $rePassWord)

                Button("Sign-up") {
                    viewModel.authState = .Signup
                    viewModel.signUp(userName: userName, passWord: passWord)
                }.background(.yellow)

                Button("Sign-in") {
                    viewModel.authState = .Signin
                }
            }
            .padding()
            .onAppear{
                viewModel.addAuthListener()
            }
        } else {
            VStack {
                TextField("Username", text: $userName)
                TextField("Password", text: $passWord)

                Button("Sign-in") {
                    viewModel.authState = .Signin
                }.background(.yellow)

                Button("Sign-up") {
                    viewModel.authState = .Signup
                }
            }
            .padding()
            .onAppear{
                viewModel.addAuthListener()
            }
        }
            
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(ViewModel())
    }
}
