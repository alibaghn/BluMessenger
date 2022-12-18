//
//  ContentView.swift
//  PingMe
//
//  Created by Ali Bagherinia on 12/8/22.
//

import Firebase
import SwiftUI

struct ChatView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var textFieldValue: String = ""
    let chatTitle:String
    @State var messages: [String] = []
    
    

    var body: some View {
        
        NavigationView {
            
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
                viewModel.addSnapShotListener()
            }
            
        }
        .navigationTitle(chatTitle)
        
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(chatTitle: "Test").environmentObject(ViewModel())
    }
}
