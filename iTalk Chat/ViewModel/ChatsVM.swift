//
//  ChatsVM.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 14/02/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

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
    @Published var image: UIImage?
    @Published var data: Data?
    private var url: URL?
    
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
            .order(by: FirebaseConstants.timestamp, descending: true)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for messages: \(error)"
                    print("Error listen message: \(error)")
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        do {
                            if let chats = try change.document.data(as: Chat.self) {
                                self.chatMessages.insert(chats, at: 0)
    
                            }
                            self.chatMessages.sort(by: { $0.timestamp < $1.timestamp })
                        } catch {
                            print("Catch Error: \(error)")
                        }
                    }
                })
            }
        DispatchQueue.main.async {
            self.count += 1
        }
    }
    
    func loadAudioUsingUrl(url: String){
        let storage = Storage.storage()
        let audioRef = storage.reference(forURL: url)
        audioRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("error downloading \(error)")
            } else {
                self.data = data
            }
        }
    }
    
    
    // MARK: - SnapshotListener
//    private func snapshotLister(_ firebaseDocument: FirebaseDocument, order: String) ->  QueryDocumentSnapshot? {
//        var queryDocumentSnapshot: QueryDocumentSnapshot?
//        firestoreListener = FirebaseManager.shared.firestore
//            .collection(firebaseDocument.firstCollection)
//            .document(firebaseDocument.firstDocument)
//            .collection(firebaseDocument.secondCollection)
//            .order(by: FirebaseConstants.timestamp)
//            .addSnapshotListener { querySnapshot, error in
//                if let error = error {
//                    print("Error snapshot listener: \(error)")
//                }
//                querySnapshot?.documentChanges.forEach({ change in
//                    if change.type == .added {
//                        queryDocumentSnapshot =  change.document
//                        print("Changed")
//                    }
//                })
//            }
//        return queryDocumentSnapshot
//    }
	
    
    // MARK: - Send Message
    func handleSend(_ typeOfContent: TypeOfContent, data: [Any]? = nil) {
        switch typeOfContent {
            case .text:
                sendText()
            case .audio:
                persistAudioToStorage()
            case .photoalbum:
                persistImageToStorage()
            default:
                break
        }
    }

    private func sendText(){
        if chatText != "" {
            print("Send Text: \(chatText)")
            sendToFirebase()
            focus = false
        }
    }
    
    // MARK: - PersistAudioToStorage
    private func persistAudioToStorage() {
        print("Saving Audio")
        var audios = [URL]()
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try? fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        for audio in directoryContents! {
            audios.append(audio)
        }
        guard let url = audios.last else { return }
        
        let metadata = StorageMetadata()
                metadata.contentType = "audio/m4a"
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        //guard let audioData = try? Data(contentsOf: url) else { return }
        ref.putFile(from: url, metadata: nil) { metadata, error in
            if let err = error {
                self.errorMessage = "Fail to save image: \(err)"
                return
            }
            ref.downloadURL { url, error in
                if let err = error {
                    self.errorMessage = "Fail to retrive downloadURL image: \(err)"
                    return
                }
                print("Success storing audio with URL \(String(describing: url?.absoluteString))")
                guard let url = url else { return }
                self.url = url
                self.typeOfContent = .audio
                self.sendToFirebase()
            }
        }
    }
    
    
    // MARK: - PersistImageToStorage
    private func persistImageToStorage() {
        print("Saving Image")
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let err = error {
                self.errorMessage = "Fail to save image: \(err)"
                return
            }
            ref.downloadURL { url, error in
                if let err = error {
                    self.errorMessage = "Fail to retrive downloadURL image: \(err)"
                    return
                }
                print("Success storing image with URL \(String(describing: url?.absoluteString))")
                guard let url = url else { return }
                self.url = url
                self.typeOfContent = .photoalbum
                self.sendToFirebase()
            }
        }
    }
    
    //    MARK: - Send To Firebase
	private func sendToFirebase() {
        var msg: Chat
		guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else { return }
		
		switch typeOfContent {
        case .text:
            msg = Chat(id: nil, fromId: uid, toId: toId, text: self.chatText, photo: nil, audio: nil, timestamp: Date())
        case .audio:
            msg = Chat(id: nil, fromId: uid, toId: toId, text: nil, photo: nil, audio: self.url?.absoluteString ?? "", timestamp: Date())
        case .photoalbum:
            msg = Chat(id: nil, fromId: uid, toId: toId, text: nil, photo: self.url?.absoluteString ?? "", audio: nil, timestamp: Date())
        default:
            msg = Chat(id: nil, fromId: uid, toId: toId, text: nil, photo: nil, audio: self.url?.absoluteString ?? "", timestamp: Date())
        }

		saveToMessagesAndRecentMessages(msg)
		self.chatText = ""
		self.count += 1
	}
	
	private func saveToMessagesAndRecentMessages(_ chat: Chat) {
//        print("----SaveToMessagesAndRecentMessages DATA: \(data)")
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else { return }
        
        var firebaseLocation = FirebaseDocument(
            firstCollection: FirebaseConstants.messages,
            firstDocument: uid,
            secondCollection: toId,
            secondDocument: nil)
 
		saveToFirebase(firebaseLocation, chat: chat)
		
		firebaseLocation.firstDocument = FirebaseConstants.messages
		firebaseLocation.firstDocument = toId
		firebaseLocation.secondCollection = uid
		saveToFirebase(firebaseLocation, chat: chat)
		
		firebaseLocation.firstDocument = FirebaseConstants.recentMessages
		firebaseLocation.firstDocument = uid
		firebaseLocation.secondCollection = FirebaseConstants.messages
        firebaseLocation.secondDocument = toId
		saveToFirebase(firebaseLocation, chat: chat)
		
		firebaseLocation.firstDocument = FirebaseConstants.recentMessages
		firebaseLocation.firstDocument = toId
		firebaseLocation.secondCollection = FirebaseConstants.messages
        firebaseLocation.secondDocument = uid
		saveToFirebase(firebaseLocation, chat: chat)
	}
    
    
    // MARK: - Save to Firebase
    private func saveToFirebase(_ firebaseDocument: FirebaseDocument, chat: Chat) {
        print("Save to Firebase Document: \(firebaseDocument)")
        print("Save to Firebase Data: \(chat)")
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
            
            try? document.setData(from: chat) { error in
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
            try? document.setData(from: chat) { error in
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
