//
//  Model.swift
//  PingMe
//
//  Created by Ali Bagherinia on 12/10/22.
//

import Foundation

enum AuthState {
    case WillSignIn, WillSignUp, DidSignIn, DidSignOut
}


struct Document: Codable{
    var date: Decimal
    var sender: String
    var message: String
}

struct User: Codable, Hashable, Identifiable {
    var id: String
    var email: String
}
