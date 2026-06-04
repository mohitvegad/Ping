import FirebaseFirestore

final class ChatService: ChatServiceProtocol {

    private let db = Firestore.firestore()
    
    func sendMessage(text: String, currentUser: UserModel, otherUser: UserModel, completion: @escaping (Result<Void, Error>) -> Void) {

        let chatId = [currentUser.id ?? "" , otherUser.id ?? ""]
            .sorted()
            .joined(separator: "_")

        let chatRef = db.collection("chats").document(chatId)

        chatRef.getDocument { snapshot, error in

            if snapshot?.exists == false {

                // CREATE CHAT ONLY ONCE
                let chatData: [String: Any] = [
                    "id": chatId,
                    "participants": [currentUser.id ?? "", otherUser.id ?? ""],
                    "updatedAt": Date()
                ]

                chatRef.setData(chatData)
            }

            // NOW SEND MESSAGE (always)

            let messageRef = chatRef.collection("messages").document()

            let message = MessageModel(
                id: messageRef.documentID,
                text: text,
                timestamp: Date(),
                senderId: currentUser.id ?? ""
            )

            do {

                try messageRef.setData(from: message)

                completion(.success(()))

            } catch {

                completion(.failure(error))
            }
        }
    }
    
    func fetchChats(uid: String, completion: @escaping ([ChatModel]) -> Void) {
        print("ERROR:", uid)
        db.collection("chats")
            .whereField("participants", arrayContains: uid)
            .addSnapshotListener { snapshot, error in

                if let error {
                    print("ERROR:", error)
                    completion([])
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }

                let chats: [ChatModel] = documents.compactMap { doc in

                    do {
                        return try doc.data(as: ChatModel.self)
                    } catch {
                        print("DECODE ERROR:", error)
                        return nil
                    }
                }

                completion(chats)
            }
    }
}
