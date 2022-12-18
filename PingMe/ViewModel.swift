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
    let fbAuth = Auth.auth()
    @Published var messages: [String] = []
    @Published var authState = AuthState.WillSignUp
    @Published var users: [String] = []
    @Published var didContentViewLoaded = false
  
    // MARK: - LoginView Functions

    func addAuthListener() {
        fbAuth.addStateDidChangeListener { _, user in
            print("Auth status changed")
            if let user {
                print("Welcome \(String(describing: user.uid))")
                self.authState = .DidSignIn
            
            } else {
                return
            }
        }
    }
    
    func signUp(userName: String, passWord: String) {
        fbAuth.createUser(withEmail: userName, password: passWord) { authResult, error in
            guard error == nil else {
                print(String(describing: error))
                return
            }
            if let authResult {
                print("Auth Result:\(authResult.user.uid)")
                self.db.collection("users").addDocument(data: ["id": authResult.user.uid, "email": authResult.user.email!])
            }
        }
    }
    
    // MARK: - UsersView Functions
    
    func fetchUsers() {
        db.collection("users").getDocuments { snapShot, error in
            guard error == nil else {
                print(String(describing: error))
                return
            }
            if let snapShot {
                self.users = snapShot.documents.map { doc in
                    doc.get("id") as! String
                }
            }
        }
    }
    
    func signOut() {
        do {
            try fbAuth.signOut()
        } catch {
            print(error)
        }
    }
    
    func createGroup(with id: String) {
        var groupId: String {
            if id < fbAuth.currentUser!.uid {
                return id + fbAuth.currentUser!.uid
            } else {
                return fbAuth.currentUser!.uid + id
            }
        }
        
        db.collection("groups").whereField("groupId", isEqualTo: groupId).getDocuments { snapShot, error in
            guard error == nil else { return }
            if let snapShot {
                if !snapShot.isEmpty {
                    print("group already exist")
                } else {
                    self.db.collection("groups").addDocument(data: ["members": [id, self.fbAuth.currentUser!.uid], "groupId": groupId])
                    print("new group added")
                }
            }
        }
    }
}
