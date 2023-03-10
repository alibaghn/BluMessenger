//
//  PingMeApp.swift
//  PingMe
//
//  Created by Ali Bagherinia on 12/8/22.
//

import Firebase
import FirebaseCore
import SwiftUI

@main
struct BluMessengerApp: App {
    @StateObject var viewModel = ViewModel()
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(viewModel)
        }
    }
}
