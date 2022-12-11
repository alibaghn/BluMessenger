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
  
    // MARK: - ContentView Functions
    
    func sendMessage(text: String) {
        db.collection("users").addDocument(data: ["message": "\(text)"]) {
            error in
            guard error == nil else {
                print("An error occured: \(String(describing: error))")
                return
            }
        }
    }
    
    func addSnapShotListener() {
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
    
    // MARK: - LoginView Functions

    func addAuthListener() {
        Auth.auth().addStateDidChangeListener { _, _ in
            print("Auth status changed")
        }
    }
    
    func signUp(userName: String, passWord: String) {
        Auth.auth().createUser(withEmail: userName, password: passWord) { authResult, error in
            guard error == nil else {
                print(String(describing: error))
                return
            }
            if let authResult {
                print("Auth Result:\(authResult.user.metadata)")
            }
        }
    }
}
