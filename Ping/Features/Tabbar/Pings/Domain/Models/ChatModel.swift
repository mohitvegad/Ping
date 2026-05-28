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

        let otherUserId = participants.first ?? "Unknown"

        return PingCellModel(
            id: otherUserId,
            title: otherUserId,
            subtitle: lastMessage,
            imageName: "person.fill"
        )
    }
}
