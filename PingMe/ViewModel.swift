//
//  ViewModel.swift
//  PingMe
//
//  Created by Ali Bagherinia on 12/10/22.
//

import Firebase
import Foundation

class ViewModel: ObservableObject {
    let db = Firestore.firestore()
    @Published var messages: [String] = []
    @Published var authState = AuthState.Signup
    
    func sendMessage(text: String) {
        db.collection("users").addDocument(data: ["message": "\(text)"]) {
            error in
            guard error == nil else {
                print("An error occured: \(String(describing: error))")
                return
            }
        }
    }

    func addListener() {
        db.collection("users").addSnapshotListener { snapShot, _ in
            guard let snapShot else { return }
            let newMessages = snapShot.documentChanges.map { doc in
                doc.document.data()["message"] as! String
            }
            newMessages.forEach { msg in
                self.messages.append(msg)
            }
            print(self.messages)
        }
    }
}
