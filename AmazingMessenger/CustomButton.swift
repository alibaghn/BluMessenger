//
//  CustomButton.swift
//  PingMe
//
//  Created by Ali Bagherinia on 12/24/22.
//

import SwiftUI

struct CustomButton: View {
    let closure: () -> Void
    let text: String
    let tintColor: Color?
    var body: some View {
        Button {
            closure()
        } label: {
            Text(text)
        }
        .buttonStyle(.borderedProminent).tint(tintColor)
    }
}
