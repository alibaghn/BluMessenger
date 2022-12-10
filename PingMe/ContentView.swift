//
//  ContentView.swift
//  PingMe
//
//  Created by Ali Bagherinia on 12/8/22.
//

import Firebase
import SwiftUI

struct ContentView: View {
    let db = Firestore.firestore()

    @State var textFieldValue: String = ""
    var body: some View {
        VStack {
            TextField("Placeholder", text: $textFieldValue)
            Button("Send") {
                var ref: DocumentReference?
                ref = db.collection("users").addDocument(data: ["message": "\(textFieldValue)"]) {
                    err in
                    if let err = err {
                        print("Error occured adding doc: \(err)")
                    } else {
                        print("Doc added with ID:\(ref!.documentID)")
                        db.collection("users").getDocuments { snapShot, error in
                            if let error {
                                print("Error occured: \(error)")
                            } else {
                                guard let snapShot else { return }
                                let docData = snapShot.documents.map { doc in
                                    doc.data()
                                }
                                print(docData)
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
