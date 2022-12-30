//
//  UsersView.swift
//  PingMe
//
//  Created by Ali Bagherinia on 12/14/22.
//

import SwiftUI

struct UsersView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var searchText = ""
    var searchResults: [User] {
        if searchText == "" {
            return viewModel.users.filter { $0.email != viewModel.currentUser?.email
            }
        } else {
            return viewModel.users.filter { $0.email.contains(searchText) && $0.email != viewModel.currentUser?.email }
        }
    }

    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        switch viewModel.authState {
        case .DidSignIn:

            VStack {
                NavigationStack {
                    K.bgColor.ignoresSafeArea().overlay {
                        ScrollView(.vertical) {
                            LazyVGrid(columns: columns) {
                                ForEach(searchResults) { user in
                                    NavigationLink(destination: ChatView(user: user)) {
                                        UserAvatar(email: user.email).padding(10)
                                    }
                                }
                            }
                            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                            .onAppear {
                                viewModel.addAuthListener()
                                viewModel.fetchUsers()
                            }.toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    HStack {
                                        Image(systemName: "person.crop.circle")
                                        Text(viewModel.currentUser!.email!.components(separatedBy: "@")[0])
                                    }
                                }

                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button {
                                        viewModel.signOut()
                                    } label: {
                                        HStack {
                                            Image(systemName: "door.left.hand.open")
                                            Text("Log out")
                                        }
                                    }
                                }
                            }
                            .toolbarBackground(.visible, for: .navigationBar)
                            .toolbarBackground(.blue, for: .navigationBar)
                        }
                        .foregroundColor(.white)
                    }
                }
            }

        default:
            LoginView().transition(.move(edge: .leading))
        }
    }
}
