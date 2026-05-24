import Foundation

struct MessageModel: Identifiable, Codable {
    var id: String
    var text: String
    var timestamp: Date
    var senderId: String
    var type: MessageKind
    var status: MessageStatus
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

