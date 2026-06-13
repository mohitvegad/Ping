import Foundation
import FirebaseFirestore

struct ChatUserState: Codable {
    @DocumentID var id: String?

    let chatId: String
    let userId: String
    let unreadCount: Int
    let lastReadAt: Date?
}
