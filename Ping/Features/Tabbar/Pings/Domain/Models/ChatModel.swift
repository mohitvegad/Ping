import Foundation
import FirebaseFirestore

struct ChatModel: Identifiable, Codable, Hashable {

    @DocumentID var id: String?

    // MARK: - Users
    
    /// Both users inside this conversation
    let participants: [String]

    /// User shown on Home screen
    let otherUserId: String
    let otherUserName: String

    // MARK: - Chat Preview
    /// Last message shown in Home screen
    let lastMessage: String?

    /// Last activity time
    let updatedAt: Date?

    /// unread count
    let unreadCount: Int?

    /// Typing indicator support
    let isTyping: Bool?
}
