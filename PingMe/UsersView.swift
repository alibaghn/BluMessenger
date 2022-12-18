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
        VStack {
            NavigationView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.users.filter({ user in
                        user != viewModel.fbAuth.currentUser?.uid
                    }), id: \.self) { user in
                        NavigationLink(destination: ChatView(userId: user)) {
                            UserAvatar(id: user)
                            // TODO: add a group to db while navigation to chatview, also customize chatview based on memebers (self and other member name)
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
    }
}

// struct UsersView_Previews: PreviewProvider {
//    static var previews: some View {
//        UsersView().environmentObject(ViewModel())
//    }
// }
