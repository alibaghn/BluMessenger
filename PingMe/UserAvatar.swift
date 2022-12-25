//
//  UserView.swift
//  PingMe
//
//  Created by Ali Bagherinia on 12/14/22.
//

import SwiftUI

struct UserAvatar: View {
    let id:String
    var body: some View {
        
        VStack{
            Image(systemName: "person.crop.circle")
            Text(id.components(separatedBy: "@")[0])
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserAvatar(id: "Ali")
    }
}
