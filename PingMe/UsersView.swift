//
//  UsersView.swift
//  PingMe
//
//  Created by Ali Bagherinia on 12/14/22.
//

import SwiftUI

struct UsersView: View {
    @EnvironmentObject var viewModel: ViewModel
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        switch viewModel.authState {
        case .DidSignIn:
            VStack {
                NavigationView {
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.users) { user in
                            NavigationLink(destination: ChatView(userId: user.email)) {
                                UserAvatar(id: user.email)
                            }
                        }
                    }
                    .onAppear {
                        viewModel.addAuthListener()
                        viewModel.fetchUsers()
                    }
                }

                Button("Sign Out") {
                    viewModel.signOut()
                }
            }

        default:
            LoginView().transition(.move(edge: .leading))
        }
    }
}

// struct UsersView_Previews: PreviewProvider {
//    static var previews: some View {
//        UsersView().environmentObject(ViewModel())
//    }
// }
