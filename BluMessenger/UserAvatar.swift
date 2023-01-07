//
//  UserView.swift
//  PingMe
//
//  Created by Ali Bagherinia on 12/14/22.
//

import SwiftUI

struct UserAvatar: View {
    let email: String
    var emailPrefix: String {
        return email.components(separatedBy: "@")[0]
    }

    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle")
            Text(emailPrefix)
        }
    }
}
