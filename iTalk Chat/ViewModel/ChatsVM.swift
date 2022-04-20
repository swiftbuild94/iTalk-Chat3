//
//  ChatsVM.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 14/02/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class ChatsVM: ObservableObject {
	@Published var chatText = ""
	@Published var errorMessage = ""
	@Published var chatMessages = [Chat]()
	@Published var count = 0
    @Published var chatUser: User?
    @Published var typeOfContent: TypeOfContent = .audio
    @Published var shouldShowImagePicker = false
    @Published var shouldShowCamara = false
    @Published var shouldShowContact = false
    @Published var shouldShowLocation = false
    @Published var shouldShowDocument = false
    @Published var focus = false
    
    var firestoreListener: ListenerRegistration?
    
	init(chatUser: User?) {
		self.chatUser = chatUser
		fetchMessages()
	}
	
    // MARK: - Fetch Messages
    private func fetchMessages() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else { return }
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.messages)
            .document(fromId)
            .collection(toId)
            .order(by: FirebaseConstants.timestamp)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for messages: \(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        self.chatMessages.append(.init(documentId: change.document.documentID, data: data))
                    }
                })
            }
        DispatchQueue.main.async {
            self.count += 1
        }
    }
    
    
    // MARK: - SnapshotListener
    private func snapshotLister(_ firebaseDocument: FirebaseDocument, order: String) ->  QueryDocumentSnapshot? {
        var queryDocumentSnapshot: QueryDocumentSnapshot?
        firestoreListener = FirebaseManager.shared.firestore
            .collection(firebaseDocument.firstCollection)
            .document(firebaseDocument.firstDocument)
            .collection(firebaseDocument.secondCollection)
            .order(by: order)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print(error)
                }
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        queryDocumentSnapshot =  change.document
                        print("Changed")
                    }
                })
            }
        return queryDocumentSnapshot
    }
	
    
    // MARK: - Send Message
    func handleSend() {
        switch typeOfContent {
            case .text:
                sendText()
            case .audio:
                break
            default:
                break
        }
    }

    func sendText(){
        if chatText != "" {
            print(chatText) 
            sendToFirebase()
            focus = false
        }
    }
    
    
    //    MARK: - Send To Firebase
	private func sendToFirebase() {
		var data: [String : Any]
		
		guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
		guard let toId = chatUser?.uid else { return }
		
		switch typeOfContent {
			case .text:
				data = [FirebaseConstants.fromId: uid,
						FirebaseConstants.toId: toId,
						FirebaseConstants.text:  self.chatText,
						FirebaseConstants.timestamp: Timestamp()] as [String : Any]
			default:
				data = [FirebaseConstants.fromId: uid,
						FirebaseConstants.toId: toId,
						FirebaseConstants.text:  self.chatText,
						FirebaseConstants.timestamp: Timestamp()] as [String : Any]
		}

		saveToMessagesAndRecentMessages(data)
		self.chatText = ""
		self.count += 1
	}
	
	private func saveToMessagesAndRecentMessages(_ data: [String : Any]) {
//        print("----SaveToMessagesAndRecentMessages DATA: \(data)")
        var firebaseLocation = FirebaseDocument(
            firstCollection: FirebaseConstants.messages,
            firstDocument: data[FirebaseConstants.fromId] as! String,
            secondCollection: data[FirebaseConstants.toId] as! String,
            secondDocument: nil)
//		firebaseLocation.firstDocument = FirebaseConstants.messages
//        firebaseLocation.firstDocument = data[FirebaseConstants.uid] as! String
//        firebaseLocation.secondCollection = data[FirebaseConstants.toId] as! String
		saveToFirebase(firebaseLocation, data: data)
		
		firebaseLocation.firstDocument = FirebaseConstants.messages
		firebaseLocation.firstDocument = data[FirebaseConstants.toId]  as! String
		firebaseLocation.secondCollection = data[FirebaseConstants.fromId] as! String
		saveToFirebase(firebaseLocation, data: data)
		
		firebaseLocation.firstDocument = FirebaseConstants.recentMessages
		firebaseLocation.firstDocument = data[FirebaseConstants.fromId] as! String
		firebaseLocation.secondCollection = FirebaseConstants.messages
        firebaseLocation.secondDocument = data[FirebaseConstants.toId] as? String
		saveToFirebase(firebaseLocation, data: data)
		
		firebaseLocation.firstDocument = FirebaseConstants.recentMessages
		firebaseLocation.firstDocument = data[FirebaseConstants.toId] as! String
		firebaseLocation.secondCollection = FirebaseConstants.messages
        firebaseLocation.secondDocument = data[FirebaseConstants.fromId] as? String
		saveToFirebase(firebaseLocation, data: data)
	}
    
    
    // MARK: - Save to Firebase
    private func saveToFirebase(_ firebaseDocument: FirebaseDocument, data: [String: Any]) {
        print("Save to Firebase Document: \(firebaseDocument)")
        print("Save to Firebase Data: \(data)")
        let collection = firebaseDocument.firstCollection
        let document = firebaseDocument.firstDocument
        let secondCollection = firebaseDocument.secondCollection
        
        if firebaseDocument.secondDocument != nil {
            guard let secondDocument = firebaseDocument.secondDocument else { return }
            let document = FirebaseManager.shared.firestore
                .collection(collection)
                .document(document)
                .collection(secondCollection)
                .document(secondDocument)
            
            document.setData(data) { error in
                if let error = error {
                    self.errorMessage = "Failed to save: \(error)"
                    print(self.errorMessage)
                    return
                }
            }
            print("Saved Messagge")
        } else {
            let document = FirebaseManager.shared.firestore
                .collection(collection)
                .document(document)
                .collection(secondCollection)
                .document()
            document.setData(data) { error in
                if let error = error {
                    self.errorMessage = "Failed to save: \(error)"
                    print(self.errorMessage)
                    return
                }
            }
            print("Saved Messagge")
        }
    }
	
}
