//
//  TextBubbleView.swift
//  PingMe
//
//  Created by Ali Bagherinia on 12/24/22.
//

import SwiftUI

struct TextBubble: View {
    let message: String
    let color: Color
    let alignment: Alignment
    var body: some View {
        Text(message)
            .padding()
            .background(color)
            .clipShape(Capsule())
            .listRowBackground(K.bgColor)
            .listRowSeparator(.hidden)
            .frame(maxWidth: .infinity, alignment: alignment)
    }
}


