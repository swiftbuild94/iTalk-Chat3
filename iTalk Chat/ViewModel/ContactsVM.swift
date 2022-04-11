//
//  ContactsVM.swift
//  iTalk
//
//  Created by Patricio Benavente on 5/09/20.
//  Copyright © 2020 Patricio Benavente. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

final class ContactsVM: ObservableObject {
	@Published var users = [User]()
	@Published var usersDictionary = [String: User]()
	@Published var currentUser: User?
    @Published var myUser: User?
    @Published var myUserUid = ""
    @Published var myUserName = ""
    @Published var myUserPhoto = ""
	@Published var errorMessage = ""
//    @Published var namesX = [String]()
//	@Published var isUserLoggedOut = true
    @Published var recentMessages = [RecentMessage]()
	var selectedUser: String?
    private var firestoreListener: ListenerRegistration?
	
	init() {
//		getCurrentUser()
		getAllUsers()
		getRecentMessagges()
	}
	
	// MARK: - Get All Users
    func getAllUsers() {
		DispatchQueue.main.async {
			self.fetchAllUsers()
		}
	}
	
	private func fetchAllUsers() {
//        print(">>>>FETCH ALL USERS<<<<")
        FirebaseManager.shared.firestore.collection("users").getDocuments { [self] documentsSnapshot, error in
			#warning("TODO: get only users in contact app")
			if let err = error {
				self.errorMessage = "Failed to get all users: \(err)"
//				print(self.errorMessage)
				return
			}
            
			documentsSnapshot?.documents.forEach({ snapshot in
				let data = snapshot.data()
                let user = User(data: data)
				if user.uid != FirebaseManager.shared.auth.currentUser?.uid {
					self.users.append(.init(data: data))
//                    namesX.append(user.name)
//                    print(self.users)
                    self.usersDictionary[user.uid] = (.init(data: data))
//					print(usersDictionary)
//                    for(userId, infor) in usersDictionary {
//                    print(namesX)
//                    }
                    //self.errorMessage =  "Users: \(self.users)"
				}
			})
		}
	}
	
	// MARK: - Get Recent Messages
	private func getRecentMessagges() {
		DispatchQueue.main.async {
			self.fetchRecentMessages()
		}
	}
	
	private func fetchRecentMessages() {
		self.recentMessages.removeAll()
		firestoreListener?.remove()
		guard let uid = currentUser?.uid else { return }
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(uid)
            .collection(FirebaseConstants.messages)
            .order(by: FirebaseConstants.timestamp)
            .addSnapshotListener { querySnapshot, error in
                if let err = error {
                    self.errorMessage = "Failed to get all users: \(err)"
    //                print(self.errorMessage)
                    return
                }
                querySnapshot?.documentChanges.forEach({ change in
                        let docId = change.document.documentID
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.documentID == docId
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    self.recentMessages.insert(.init(documentId: docId, data: change.document.data()), at: 0)
                })
                self.errorMessage = "Messages: \(self.recentMessages)"
            }
	}
				
	// MARK: - Intents
	//	func addUser() {
	//		let user = Contacts.User(name: "String", photo: "String")
	//		self.model.addUser(user)
	//	}
	//
	//	func removeUser(id: UUID) {
	//		let notError = self.model.removeUser(id: id)
	//		print("Removed: \(notError) id:\(id)")
	//	}
}
