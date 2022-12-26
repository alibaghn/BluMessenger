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
    let user: User
    @State var documents: [Document] = []
    @State var listener: ListenerRegistration?

    var groupId: String {
        if user.id < viewModel.fbAuth.currentUser!.uid {
            return user.id + viewModel.fbAuth.currentUser!.uid
        } else {
            return viewModel.fbAuth.currentUser!.uid + user.id
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                List(documents, id: \.date) { doc in
                    viewModel.fbAuth.currentUser?.uid == doc.sender ?
                        TextBubble(message: doc.message, color: Color.green, alignment: .trailing) :
                        TextBubble(message: doc.message, color: Color.blue, alignment: .leading)
                }.scrollContentBackground(.hidden)
                    .background(K.bgColor)

                ZStack(alignment: .trailing) {
                    TextField("Message", text: $textFieldValue)
                    if textFieldValue != "" {
                        Button {
                            guard textFieldValue != "" else { return }
                            viewModel.sendMessage(text: textFieldValue, groupId: groupId)
                            textFieldValue = ""
                        } label: {
                            Image(systemName: "paperplane.fill")
                        }
                    } else {
                        Button {} label: {
                            Image(systemName: "paperplane.fill").foregroundColor(.gray)
                        }
                    }
                }
            }
            .padding()
            .onAppear {
                viewModel.createGroupId(with: user.id)
                addSnapShotListener()
            }

            .onDisappear {
                listener?.remove()
            }
        }
        .navigationTitle(user.email)
    }
}

extension ChatView {
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
}
