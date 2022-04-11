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
//    let readtime: Date?
    
    init(documentId: String, data: [String:Any]) {
        self.id = documentId
        self.fromId = data["fromId"] as? String ?? ""
        self.toId = data["toId"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
        self.timestamp = data["timestamp"] as? String ?? ""
    }
    
}
