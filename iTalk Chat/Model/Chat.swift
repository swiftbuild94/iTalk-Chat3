//
//  Chat.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 21/02/2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Chat: Identifiable, Codable {
    @DocumentID var id: String?
    
    let fromId: String
    let toId: String
//    let typeOfContent: TypeOfContent
    let text: String?
//    let contentAudio: Data?
//    let contentVideo: Data?
//    let duration: String?
//    let location: String?
    let timestamp: String?
    let photo: String?
//    let readtime: Date?
    
    init(documentId: String, data: [String:Any]) {
        self.id = documentId
        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
        self.toId = data[FirebaseConstants.toId] as? String ?? ""
        self.text = data[FirebaseConstants.text] as? String ?? ""
        self.timestamp = data[FirebaseConstants.timestamp] as? String ?? ""
        self.photo = data[FirebaseConstants.photo] as? String
    }
    
}
