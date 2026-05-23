import Foundation

struct MessageModel: Identifiable, Codable {
    let id: String
    let text: String
    let timestamp: Date
    let senderId: String
    let type: MessageKind
    let status: MessageStatus
}

enum MessageKind: String, Codable {
    case text
    case image
    case audio
}

enum MessageStatus: String, Codable {
    case sending
    case sent
    case delivered
    case seen
}

