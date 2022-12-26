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
        Text(message).frame(maxWidth: .infinity, alignment: alignment).listRowBackground(RoundedRectangle(cornerRadius: 20)
            .background(color)
            .foregroundColor(.clear)
            .padding(
                EdgeInsets(
                    top: 2,
                    leading: 10,
                    bottom: 2,
                    trailing: 10
                )
            ))
        .listRowSeparator(.hidden)
    }
}
