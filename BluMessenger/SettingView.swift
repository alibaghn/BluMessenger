//
//  SettingView.swift
//  BluMessenger
//
//  Created by Ali Bagherinia on 1/11/23.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var isConfirmPresent = false
    var body: some View {
        K.bgColor.ignoresSafeArea().overlay {
            VStack {
                Spacer()
                Button {
                    viewModel.signOut()
                } label: {
                    Text("Log out")
                }.buttonStyle(.borderedProminent)
                Spacer()
                Divider()
                Spacer()

                Button("Delete Account", role: .destructive) {
                    isConfirmPresent = true
                }.confirmationDialog("Delete Account?", isPresented: $isConfirmPresent) {
                    Button("Yes, delete my account", role: .destructive) {
                        viewModel.deleteAccount()
                    }
                } message: {
                    Text("Are you sure you want to delete your account?")
                }.buttonStyle(.borderedProminent)

                Spacer()
            }
        }.foregroundColor(.white)
    }
}
