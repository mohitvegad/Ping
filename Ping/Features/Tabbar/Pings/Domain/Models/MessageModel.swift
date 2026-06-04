import Foundation
import FirebaseFirestore

struct MessageModel: Identifiable, Codable, Hashable {

    @DocumentID var id: String?

    let text: String
    let senderId: String
    let timestamp: Date
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


