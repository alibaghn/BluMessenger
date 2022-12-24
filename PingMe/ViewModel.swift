//
//  ViewModel.swift
//  PingMe
//
//  Created by Ali Bagherinia on 12/10/22.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    let db = Firestore.firestore()
    let fbAuth = Auth.auth()
    @Published var messages: [String] = []
    @Published var authState = AuthState.WillSignUp
    @Published var users: [User] = []
    @Published var userEmails: [String] = []
    @Published var didContentViewLoaded = false
    @Published var signUpError = false
    @Published var signUpErrorDescription = ""
    @Published var signInError = false
    @Published var signInErrorDescription = ""
  
    // MARK: - LoginView Functions

    func addAuthListener() {
        fbAuth.addStateDidChangeListener { _, user in
            if let user {
                print("Welcome \(String(describing: user.uid))")
                self.authState = .DidSignIn
                
            } else {
                return
            }
        }
    }
    
    func signUp(email: String, password: String) {
        fbAuth.createUser(withEmail: email, password: password) { authResult, error in
            guard error == nil else {
                print(String(describing: error))
                self.signUpErrorDescription = error!.localizedDescription
                self.signUpError = true
                return
            }
            if let authResult {
                print("Auth Result:\(authResult.user.uid)")
                self.db.collection("users").addDocument(data: ["id": authResult.user.uid, "email": authResult.user.email!])
            }
        }
    }
    
    func signIn(email: String, password: String) {
        fbAuth.signIn(withEmail: email, password: password) { authResult, error in
            guard error == nil else {
                self.signInErrorDescription = error!.localizedDescription
                self.signInError = true
                return
            }
            if let authResult {
                print("sucessful login: \(authResult.user.uid)")
                self.authState = .DidSignIn
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
                self.users = snapShot.documents.compactMap {
                    try? $0.data(as: User.self)
                }
                
                self.userEmails = self.users.map { user in
                    user.email
                }
            }
        }
    }
    
    func signOut() {
        do {
            try fbAuth.signOut()
            authState = .DidSignOut
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
