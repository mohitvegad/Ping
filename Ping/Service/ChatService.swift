import FirebaseFirestore

final class ChatService {

    private let db = Firestore.firestore()

    // MARK: - SEND MESSAGE
    func sendMessage(chatId: String, otherUserId: String, message: MessageModel) {

        let currentUserId = CurrentUserSession.shared.id ?? ""

        // 1. Save message
        let messageData: [String: Any] = [
            "text": message.text,
            "timestamp": message.timestamp,
            "senderId": message.senderId
        ]

        db.collection("chats")
            .document(chatId)
            .collection("messages")
            .addDocument(data: messageData)

        // 2. Create chat FOR HOME SCREEN
        let chatData: [String: Any] = [
            "participants": [currentUserId, otherUserId],
            "lastMessage": message.text,
            "updatedAt": message.timestamp
        ]

        db.collection("chats")
            .document(chatId)
            .setData(chatData, merge: true)
    }

    // MARK: - OBSERVE CHATS (HOME SCREEN)
    func observeChats(userId: String, completion: @escaping ([ChatModel]) -> Void) {

        db.collection("chats")
            .whereField("participants", arrayContains: userId)
            .addSnapshotListener { snapshot, _ in

                let chats: [ChatModel] = snapshot?.documents.compactMap {
                    try? $0.data(as: ChatModel.self)
                } ?? []

                completion(chats)
            }
    }

    // MARK: - OBSERVE MESSAGES
    func observeMessages(chatId: String, completion: @escaping ([MessageModel]) -> Void) {

        db.collection("chats")
            .document(chatId)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, _ in

                let messages: [MessageModel] = snapshot?.documents.compactMap {
                    try? $0.data(as: MessageModel.self)
                } ?? []

                completion(messages)
            }
    }


}
