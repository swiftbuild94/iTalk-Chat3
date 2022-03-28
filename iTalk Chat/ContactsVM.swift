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
	@Published var users =  [User]()
	@Published var usersDictionary = [String: User]()
	@Published var currentUser: User?
	@Published var errorMessage = ""
	@Published var isUserLoggedOut = false
//    @Published var recentMessages = [RecentMessage].self
	var selectedUser: String?
    private var firestoreListener: ListenerRegistration?
	
	init() {
		getCurrentUser()
		getAllUsers()
		getRecentMessagges()
	}
	
	// MARK: - Get Current User
	private func getCurrentUser() {
        print("Current User")
		DispatchQueue.main.async {
			if FirebaseManager.shared.auth.currentUser?.uid == nil {
				self.isUserLoggedOut = true
			} else {
                self.selectedUser = FirebaseManager.shared.auth.currentUser?.uid
//                let name = FirebaseManager.shared.auth.currentUser?.name
				self.fethCurrentUser(self.selectedUser!)
//                self.currentUser = User(uid: selectedUser!, name: name)
			}
		}
	}
	
	private func fethCurrentUser(_ uid: String) {
        print("Fetch Current User: \(uid)")
//        let name = FirebaseManager.shared.auth.currentUser?.name
//        currentUser = User(uid: uid, name: name)
		FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { [self] snapshot, error in
			if let err = error {
				self.errorMessage = "Failed getting current user: \(err)"
				print(self.errorMessage)
				return
			}
			guard let data = snapshot?.data() else {
				self.errorMessage = "No data found"
				print(self.errorMessage)
				return
			}
			print("Current User data: \(data)")
//            currentUser = .init(data)
		}
	}
	
	
	// MARK: - Get All Users
    func getAllUsers() {
		DispatchQueue.main.async {
			self.fetchAllUsers()
		}
	}
	
	private func fetchAllUsers() {
        FirebaseManager.shared.firestore.collection("users").getDocuments { [self] documentsSnapshot, error in
			#warning("TODO: get only users in contact app")
			if let err = error {
				self.errorMessage = "Failed to get all users: \(err)"
				print(self.errorMessage)
				return
			}
			documentsSnapshot?.documents.forEach({ snapshot in
				let data = snapshot.data()
//                let user = User(from: data)
//				if user.uid != self.selectedUser {
//					self.users.append(.init(data: data))
//                    self.usersDictionary[user.uid] = (.init(data: data))
//					print(usersDictionary)
//				}
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
////		self.recentMessages.removeAll()
//		firestoreListener?.remove()
//		guard let uid = currentUser?.uid else { return }
//		var firebaseLocation: FirebaseDocument
//		firebaseLocation.firstCollection = FirebaseConstants.recentMessages
//		firebaseLocation.firstDocument = uid
//		firebaseLocation.secondCollection = FirebaseConstants.messages
//		let order = FirebaseConstants.timestamp
//		
//		let snapResult = snapshotLister(firebaseLocation, order: order)
//		let docId = snapResult.documentID
//		let data = snapResult.data()
//		
//		if let index = self.recentMessages.index(where: { rm in
//			return rm.id == docId
//		}){
//			self.recentMessages.remove(at: index)
//		}
//		if let cm = try change.document.data(as: RecentMessage.self) {
//			self.recentMessages.append(cm)
//			print("Recent Message Appended \(cm)")
//		}
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
