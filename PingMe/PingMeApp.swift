//
//  PingMeApp.swift
//  PingMe
//
//  Created by Ali Bagherinia on 12/8/22.
//

import SwiftUI
import Firebase
import FirebaseCore

@main
struct PingMeApp: App {
    @StateObject var viewModel = ViewModel()
    init() {
        FirebaseApp.configure()
        
    }
    
    var body: some Scene {
        WindowGroup {
             UsersView()
                .environmentObject(viewModel)
        }
    }
}
