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
import FirebaseStorage
import FirebaseStorageSwift

/// To Get All Users and Recent Messages
///
/// Used in iTalkView and HistoryView
final class ContactsVM: ObservableObject {
	@Published var users = [User]()
    @Published var unshownUsers = [User]()
	@Published var usersDictionary = [String: User]()
    @Published var unshownUsersDictionary = [String: User]()
	@Published var currentUser: User?
    @Published var myUser: User?
    @Published var myUserUid = ""
    @Published var myUserName = ""
    @Published var myUserPhoto = ""
	@Published var errorMessage = ""
    @Published var count = 0
    @Published var isShowChat = false
    @ObservedObject var notificationManager = NotificationManager()
//    @Published var namesX = [String]()
//	@Published var isUserLoggedOut = true
    @Published var recentMessages = [RecentMessage]()
	var selectedUser: String?
    private var firestoreListener: ListenerRegistration?
    
    /// On Init get all users andall recent messages
    init() {
        DispatchQueue.main.async() {
            self.getAllUsers()
            self.getRecentMessagges()
        }
    }
    
    deinit {
        firestoreListener?.remove()
    }
	
	// MARK: - Get All Users
    func getAllUsers() {
        self.fetchAllUsers()
	}
	
    /// Connects to Firestore and get all users
    ///
    /// - Returns: all the users in 3 differents arrays
	private func fetchAllUsers() {
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.users)
            .order(by: FirebaseConstants.name, descending: false)
            .getDocuments { [self] documentsSnapshot, error in
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
                    print(">>>>FETCH ALL USERS<<<<")
                   // DispatchQueue.main.async {
                        self.users.append(.init(data: data))
                        //print("User: \(self.users)")
                        self.usersDictionary[user.uid] = (.init(data: data))
                        self.unshownUsersDictionary[user.uid] = (.init(data: data))
                    //}
				}
			})
                print("Users Count: \(self.users.count)")
		}
	}
	
	// MARK: - Get Recent Messages
	func getRecentMessagges() {
//		DispatchQueue.main.async {
			self.fetchRecentMessages()
//		}
	}
	
    /// - Returns: all recent Messages and an array if usersWithOutReccentMessages
	private func fetchRecentMessages() {
        var badge = 0
		//self.recentMessages.removeAll()
        self.firestoreListener?.remove()
		guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        //print(">>>>>>fetchRecentMessages")
        firestoreListener = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(uid)
            . collection(FirebaseConstants.messages)
            .order(by: FirebaseConstants.timestamp, descending: true)
            .addSnapshotListener { querySnapshot, error in
                if let err = error {
                    self.errorMessage = "Failed to get all users: \(err)"
                    print(self.errorMessage)
                    return
                }
                querySnapshot?.documentChanges.forEach({ change in
                    // let docId = change.document.documentID
//                    if let index = self.recentMessages.firstIndex(where: {
//                        $0.id == docId
//                    }) {
//                       //self.recentMessages.remove(at: index)
//                    }
                    do {
                        if let rm = try change.document.data(as: RecentMessage?.self) {
                            print(">>>>>Fetch Recent Messages<<<<<")
                            badge += 1
                            self.recentMessages.append(rm)
                            //print("RecentMessages: \(self.recentMessages)")
                            self.unshownUsersDictionary.removeValue(forKey: rm.toId)
                            
                            let user = self.usersDictionary[rm.toId]
                            
                            var body = ""
                            if rm.audioTimer == nil {
                                body = rm.text ?? "Photo"
                            } else {
                                body = String("Audio: \(rm.audioTimer)")
                            }
                            
                            self.notificationManager.sendNotification(title: "iTalk", subtitle: user?.name, body: body, launchIn: 5, badge: badge)
                            print("RecentMessages User: \(String(describing: user?.name))")
                        }
                        self.unshownUsers = Array(self.unshownUsersDictionary.values.map { $0 })
                        
                        self.recentMessages.sort(by: { $0.timestamp > $1.timestamp })
                        print("Unshown Users: \(String(describing: self.unshownUsers))")
                    } catch {
                        print(error)
                    }
                })
            }
	}
}
