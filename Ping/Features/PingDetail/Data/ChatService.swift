import FirebaseFirestore

final class ChatService {

    private let db = Firestore.firestore()

    func sendMessage(chatId: String, message: MessageModel) {

        let data: [String: Any] = [
            "text": message.text,
            "timestamp": message.timestamp,
            "senderId": message.senderId,
            "type": message.type.rawValue,
            "status": message.status.rawValue
        ]

        db.collection("chats")
            .document(chatId)
            .collection("messages")
            .addDocument(data: data)
    }
    
    func observeMessages(chatId: String, completion: @escaping ([MessageModel]) -> Void) {

        db.collection("chats")
            .document(chatId)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in

                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }

                let messages: [MessageModel] = documents.compactMap { doc in
                    try? doc.data(as: MessageModel.self)
                }

                completion(messages)
            }
    }
}
