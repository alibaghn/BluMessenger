//
//  UserView.swift
//  PingMe
//
//  Created by Ali Bagherinia on 12/14/22.
//

import SwiftUI

struct UserAvatar: View {
    let name:String
    var body: some View {
        
        VStack{
            Image(systemName: "person.crop.circle")
            Text(name)
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserAvatar(name: "Ali")
    }
}
