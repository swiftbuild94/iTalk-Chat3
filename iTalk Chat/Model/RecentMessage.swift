//
//  RecentMessage.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 16/02/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct RecentMessage: Identifiable, Codable {
    @DocumentID var id: String?
    let fromId, toId: String
    let text: String
    let timestamp: Date
    var timeAgo: String {
        let formater = RelativeDateTimeFormatter()
        formater.unitsStyle = .abbreviated
        return formater.localizedString(for: timestamp, relativeTo: Date())
    }
}
