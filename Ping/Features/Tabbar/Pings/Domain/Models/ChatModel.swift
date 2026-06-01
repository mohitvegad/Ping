import Foundation
import FirebaseFirestore

struct ParticipantInfo: Codable, Hashable {
    let name: String
}


struct ChatModel: Identifiable, Codable, Hashable {

    @DocumentID var id: String?

    let participants: [String]
    let participantInfo: [String: ParticipantInfo]

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


extension ChatModel {
    func otherUserId(currentUserId: String) -> String {
        participants.first { $0 != currentUserId } ?? ""
    }

}
