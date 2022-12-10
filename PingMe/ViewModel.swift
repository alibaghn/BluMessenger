//
//  ViewModel.swift
//  PingMe
//
//  Created by Ali Bagherinia on 12/10/22.
//

import Firebase
import Foundation

class ViewModel {
    let db = Firestore.firestore()
    var messages: [String] = []

    func sendMessage(text: String) {
        db.collection("users").addDocument(data: ["message": "\(text)"]) {
            error in
            guard error == nil else {
                print("An error occured: \(String(describing: error))")
                return
            }
        }
    }

    func fetchMessages() {
        db.collection("users").getDocuments { snapShot, error in

            guard error == nil, let snapShot else { return }
            self.messages = snapShot.documents.map { doc in
                doc.data()["message"] as! String
            }
            print(self.messages)

        }
    }
}
