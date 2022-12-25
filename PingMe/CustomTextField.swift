//
//  CustomTextField.swift
//  PingMe
//
//  Created by Ali Bagherinia on 12/24/22.
//

import SwiftUI

struct CustomTextField: View {
    let title: String
    @Binding var text: String

    var body: some View {
        TextField(title, text: $text).textFieldStyle(.roundedBorder)
    }
}
