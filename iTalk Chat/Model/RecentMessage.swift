//
//  RecentMessage.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 16/02/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct RecentMessage: Identifiable, Hashable {
    @DocumentID var id: String?
    let documentID: String
    let fromId, toId: String
    let text: String
    let timestamp: Timestamp
//    var timeAgo: String {
//        let formater = RelativeDateTimeFormatter()
//        formater.unitsStyle = .abbreviated
//        return formater.localizedString(for: timestamp, relativeTo: Date())
//    }
    
    init(documentId: String, data: [String:Any]) {
        self.id = documentId
        self.documentID = data["documentID"] as? String ?? ""
        self.fromId = data["fromId"] as? String ?? ""
        self.toId = data["toId"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
