import FirebaseFirestore


final class ChatService: ChatServiceProtocol {

    private let db = Firestore.firestore()

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
