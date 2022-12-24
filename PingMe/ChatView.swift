//
//  ContentView.swift
//  PingMe
//
//  Created by Ali Bagherinia on 12/8/22.
//

import Firebase
import FirebaseFirestoreSwift
import SwiftUI

struct ChatView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var textFieldValue: String = ""
    let userId: String
    @State var documents: [Document] = []
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
                List(documents, id: \.date) { doc in

                    viewModel.fbAuth.currentUser?.uid == doc.sender ?
                        Text(doc.message).frame(maxWidth: .infinity, alignment: .trailing) :
                        Text(doc.message).frame(maxWidth: .infinity, alignment: .leading)
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
        viewModel.db.collection("chats").addDocument(data: ["message": "\(text)", "id": groupId, "date": Date().timeIntervalSince1970, "sender": viewModel.fbAuth.currentUser!.uid]) {
            error in
            guard error == nil else {
                print("An error occured: \(String(describing: error))")
                return
            }
        }
    }

    func addSnapShotListener() {
        listener = viewModel.db.collection("chats")
            .whereField("id", isEqualTo: groupId)
            .order(by: "date", descending: false)
            .addSnapshotListener { snapShot, _ in
                guard let snapShot else { return }
                let newDocuments = snapShot.documentChanges.compactMap {
                    try? $0.document.data(as: Document.self)
                }
                newDocuments.forEach { doc in
                    documents.append(doc)
                    print(documents)
                }
            }
    }

    func removeSnapShotListener() {
        listener?.remove()
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ChatView(userId: "Test").environmentObject(ViewModel())
        }
    }
}
