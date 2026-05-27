import Foundation
import FirebaseFirestore

struct MessageModel: Identifiable, Codable {

    @DocumentID var id: String?

    let text: String
    let timestamp: Date
    let senderId: String
    let type: MessageType
    let status: MessageStatus
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


