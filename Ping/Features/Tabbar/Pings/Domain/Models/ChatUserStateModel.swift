import Foundation
import FirebaseFirestore

struct ChatUserState: Codable {
    let chatId: String
    let userId: String
    let lastReadAt: Date?
}
