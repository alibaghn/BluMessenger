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
        LazyVGrid(columns: columns) {
            ForEach(viewModel.users, id: \.self) { user in
                UserView(name: user)
            }
        }
        .onAppear{
            viewModel.fetchUsers()
        }
    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        UsersView().environmentObject(ViewModel())
    }
}
