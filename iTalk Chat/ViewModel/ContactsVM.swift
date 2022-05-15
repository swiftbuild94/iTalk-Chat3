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
    @Published var count = 0
//    @Published var namesX = [String]()
//	@Published var isUserLoggedOut = true
    @Published var recentMessages = [RecentMessage]()
	var selectedUser: String?
    private var firestoreListener: ListenerRegistration?
	
	init() {
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
				print(self.errorMessage)
				return
			}
            
			documentsSnapshot?.documents.forEach({ snapshot in
                let data = snapshot.data()
                let user = User(data: data)
				if user.uid != FirebaseManager.shared.auth.currentUser?.uid {
					self.users.append(.init(data: data))
                    self.usersDictionary[user.uid] = (.init(data: data))
				}
			})
		}
	}
	
	// MARK: - Get Recent Messages
	private func getRecentMessagges() {
//		DispatchQueue.main.async {
			self.fetchRecentMessages()
//		}
	}
	
	private func fetchRecentMessages() {
        print(">>>>>Fetch Recent Messages<<<<<")
		self.recentMessages.removeAll()
		firestoreListener?.remove()
		guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(uid)
            .collection(FirebaseConstants.messages)
            .order(by: FirebaseConstants.timestamp)
            .addSnapshotListener { querySnapshot, error in
                if let err = error {
                    self.errorMessage = "Failed to get all users: \(err)"
                    print(self.errorMessage)
                    return
                }
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        self.errorMessage = "3"
                        return rm.id == docId
                    }) {
                        self.errorMessage = "4"
                        self.recentMessages.remove(at: index)
                    }
                    do {
                        if let rm = try change.document.data(as: RecentMessage.self) {
                            self.recentMessages.insert(rm, at: 0)
                            self.errorMessage = "Messages: \(self.recentMessages)"
                        }
                    } catch {
                        print(error)
                    }
                })
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
