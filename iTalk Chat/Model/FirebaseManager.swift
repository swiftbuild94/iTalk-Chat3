//
//  FirebaseManager.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 4/12/21.
//

import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseStorageSwift

struct FirebaseDocument {
	var firstCollection: String
	var firstDocument: String
	var secondCollection: String
	var secondDocument: String?
    
    init(firstCollection: String, firstDocument: String, secondCollection: String, secondDocument: String?){
        self.firstCollection = firstCollection
        self.firstDocument = firstDocument
        self.secondCollection = secondCollection
        self.secondDocument = secondDocument
    }
}

class FirebaseManager: NSObject {
	
	let auth: Auth
	let storage: Storage
	let firestore: Firestore
	
	static let shared = FirebaseManager()
	var firestoreListener: ListenerRegistration?
	
	override init() {
		FirebaseApp.configure()
		self.auth = Auth.auth()
		self.storage = Storage.storage()
		self.firestore = Firestore.firestore()
		super.init()
	}
	
	// MARK: - Stop firestoreListener
	func stopFirestoreListener() {
		firestoreListener?.remove()
		print("ChatsVM: firestoreListener removed")
	}
	
}
