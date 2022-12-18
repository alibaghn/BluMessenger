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
    let userId: String
    @State var messages: [String] = []
    @State var listener: ListenerRegistration?

    var groupId: String {
        if userId < viewModel.fbAuth.currentUser!.uid {
            return userId + viewModel.fbAuth.currentUser!.uid
        } else {
            return viewModel.fbAuth.currentUser!.uid + userId
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                List(messages, id: \.self) { message in Text(message)
                }

                TextField("Placeholder", text: $textFieldValue)
                Button("Send") {
                    sendMessage(text: textFieldValue)
                    textFieldValue = ""
                    
                }
            }
            .padding()
            .onAppear {
                viewModel.createGroup(with: userId)
                addSnapShotListener()
            }

            .onDisappear {
                removeSnapShotListener()
            }
        }
        .navigationTitle(userId)
    }
}

extension ChatView {
    func sendMessage(text: String) {
        viewModel.db.collection("chats").addDocument(data: ["message": "\(text)", "groupId": groupId, "date": Date().timeIntervalSince1970]) {
            error in
            guard error == nil else {
                print("An error occured: \(String(describing: error))")
                return
            }
        }
    }

    func addSnapShotListener() {
        listener = viewModel.db.collection("chats")
            .whereField("groupId", isEqualTo: groupId)
            .order(by: "date", descending: false)
            .addSnapshotListener { snapShot, _ in
                guard let snapShot else { return }
                let newMessages = snapShot.documentChanges.map { doc in
                    doc.document.data()["message"] as? String
                }
                
                newMessages.forEach { msg in
                    self.messages.append(msg ?? "No msg here yet!")
                }
            }
    }

    func removeSnapShotListener() {
        listener?.remove()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(userId: "Test").environmentObject(ViewModel())
    }
}
