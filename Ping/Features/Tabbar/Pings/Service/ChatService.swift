import FirebaseFirestore


final class ChatService: ChatServiceProtocol {

    private let db = Firestore.firestore()
    
    func createChat(currentUserId: String, otherUserId: String,completion: @escaping (String) -> Void) {

        let chatId = [currentUserId, otherUserId].sorted().joined(separator: "_")

        let data: [String: Any] = [
            "participants": [currentUserId, otherUserId],
            "chatId": chatId,
            "lastMessage": "",
            "updatedAt": Date()
        ]

        Firestore.firestore()
            .collection("chats")
            .document(chatId)
            .setData(data, merge: true) { error in

                if let error = error {
                    print(error.localizedDescription)
                    return
                }

                completion(chatId)
            }
    }

    func fetchChats(uid: String, completion: @escaping ([ChatModel]) -> Void) {

        db.collection("chats")
            .whereField("participants", arrayContains: uid)
            .addSnapshotListener { snapshot, error in

                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }

                let chats: [ChatModel] = documents.compactMap {
                    try? $0.data(as: ChatModel.self)
                }

                completion(chats)
            }
    }
}
