import Foundation
import FirebaseFirestore

struct ChatModel: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    let participants: [String]
    let deletedFor: [String]?
    let lastMessage: String
    let updatedAt: Date
}

extension ChatModel {
    func otherUserId(currentUserId: String) -> String {
        participants.first { $0 != currentUserId } ?? ""
    }
}
