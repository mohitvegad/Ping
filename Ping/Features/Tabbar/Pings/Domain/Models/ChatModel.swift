import Foundation

struct ChatModel: Identifiable, Hashable {

    let id: String
    let userId: String
    let userName: String

    let lastMessage: String?
    let updatedAt: Date?
}
