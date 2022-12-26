//
//  UserView.swift
//  PingMe
//
//  Created by Ali Bagherinia on 12/14/22.
//

import SwiftUI

struct UserAvatar: View {
    let email: String
    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle")
            Text(email.components(separatedBy: "@")[0])
        }
    }
}