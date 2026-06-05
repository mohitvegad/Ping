import Foundation
import FirebaseFirestore

struct ChatModel: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    let participants: [String]
    let lastMessage: String
    let updatedAt: Date
    
}

extension ChatModel {
    func toPingCellModel() -> PingCellModel {
        let otherUserId = otherUserId(currentUserId: CurrentUserSession.shared.userId ?? "")
        let otherUser = UserStore.shared.user(id: otherUserId)

        return PingCellModel(
            id: otherUser?.id ?? "",
            title: "\(otherUser?.firstName ?? "") \(otherUser?.lastName ?? "")",
            subtitle: lastMessage,
            imageName: "person.fill"
        )
    }
}


extension ChatModel {
    func otherUserId(currentUserId: String) -> String {
        participants.first { $0 != currentUserId } ?? ""
    }

}
