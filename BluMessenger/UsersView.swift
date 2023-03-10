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
            return viewModel.favUsers
        } else {
            return viewModel.users.filter { $0.email.localizedCaseInsensitiveContains(searchText) && $0.email != viewModel.currentUser?.email }
        }
    }

    init() {
        UINavigationBar.setAnimationsEnabled(false)
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
                            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Seach User ID")
                            .onAppear {
                                UISearchBar.appearance().tintColor = UIColor.white
                                viewModel.addAuthListener()
                                viewModel.fetchUsers()
                            }
                            .onDisappear {
                                searchText = ""
                            }
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    HStack {
                                        Image(systemName: "person.crop.circle")
                                        Text(viewModel.currentUser!.email!.components(separatedBy: "@")[0])
                                    }
                                }

                                ToolbarItem(placement: .navigationBarTrailing) {
                                    NavigationLink {
                                        SettingView()

                                    } label: {
                                        HStack {
                                            Image(systemName: "gearshape.circle.fill")
                                            Text("Settings")
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

// HStack {
//    Image(systemName: "door.left.hand.open")
//    Text("Log out")
// }
