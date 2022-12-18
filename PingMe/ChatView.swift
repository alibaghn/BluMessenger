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
    @State var messages : [String] = []
    @State var listener: ListenerRegistration?
    
    

    var body: some View {
        
        NavigationView {
            
            VStack {
                List(messages, id: \.self) { message in Text(message)
                }

                TextField("Placeholder", text: $textFieldValue)
                Button("Send") {
                    sendMessage(text: textFieldValue)
                }
            }
            .padding()
            .onAppear {
                addSnapShotListener()
            }
            
            .onDisappear{
                removeSnapShotListener()
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


extension ChatView {
    
    func sendMessage(text: String) {
        viewModel.db.collection("chats").addDocument(data: ["message": "\(text)"]) {
            error in
            guard error == nil else {
                print("An error occured: \(String(describing: error))")
                return
            }
        }
    }
    
   
    func addSnapShotListener() {
        listener = viewModel.db.collection("chats").addSnapshotListener { snapShot, _ in
            guard let snapShot else { return }
            let newMessages = snapShot.documentChanges.map { doc in
                doc.document.data()["message"] as? String
            }
         
            newMessages.forEach { msg in
                self.messages.append(msg ?? "No msg here yet!")
            }
            
            
        }
    }
    
    
    func removeSnapShotListener(){
        listener?.remove()
    }
}
