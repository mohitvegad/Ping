import Foundation
import FirebaseFirestore

struct MessageModel: Identifiable, Codable {
    
    var id: String
    let text: String
    let timestamp: Date
    let senderId: String
}

enum MessageType: String, Codable {
    case text
}

enum MessageStatus: String, Codable {
    case sending
    case sent
    case delivered
    case read
}


