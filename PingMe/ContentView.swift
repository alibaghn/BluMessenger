//
//  ContentView.swift
//  PingMe
//
//  Created by Ali Bagherinia on 12/8/22.
//

import Firebase
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel : ViewModel
    @State var textFieldValue: String = ""

    var body: some View {
        VStack {
            
            List(viewModel.messages, id: \.self) { message in Text(message)
            }
            
            
            TextField("Placeholder", text: $textFieldValue)
            Button("Send") {
                viewModel.sendMessage(text: textFieldValue)
            }
        }
        .padding()
        .onAppear {
            viewModel.addListener()
            print(viewModel.messages)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewModel())
    }
}
