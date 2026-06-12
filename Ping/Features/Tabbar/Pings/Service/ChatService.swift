import FirebaseFirestore

final class ChatService: ChatServiceProtocol {
    
    private let db = Firestore.firestore()
    
    //MARK: - CHAT SERVICE
    
    func fetchChats(uid: String, completion: @escaping ([ChatModel]) -> Void) {
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
                
                let visibleChats = chats.filter {
                    !($0.deletedFor?.contains(uid) ?? false)
                }
                
                completion(visibleChats)
            }
    }
    
    //MARK: - MESSAGE SERVICE
    
    func sendMessage(text: String, currentUser: UserModel, otherUser: UserModel, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let chatId = createChatId(currentUser: currentUser, otherUser: otherUser)
        let chatRef = db.collection("chats").document(chatId)
        
        chatRef.getDocument { snapshot, error in
            
            if snapshot?.exists == false {
                chatRef.setData([
                    "id": chatId,
                    "participants": [currentUser.id ?? "", otherUser.id ?? ""],
                    "deletedFor": [],
                    "lastMessage": text,
                    "updatedAt": FieldValue.serverTimestamp()
                ])
            } else {
                chatRef.updateData([
                    "lastMessage": text,
                    "updatedAt": FieldValue.serverTimestamp()
                ])
            }
            
            let messageRef = chatRef.collection("messages").document()
            
            let message = MessageModel(
                id: messageRef.documentID,
                text: text,
                senderId: currentUser.id ?? "",
                timestamp: Date(),
                status: .sent
            )
            
            try? messageRef.setData(from: message)
            completion(.success(()))
        }
    }
    
    
    func fetchMessages(currentUser: UserModel, otherUser: UserModel, completion: @escaping ([MessageModel]) -> Void) {
        
        let chatId: String = createChatId(currentUser: currentUser, otherUser: otherUser)
        
        db.collection("chats")
            .document(chatId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
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
    
    func markMessagesAsSeen(currentUser: UserModel, otherUser: UserModel) {
        
        let chatId: String = createChatId(currentUser: currentUser, otherUser: otherUser)
        
        let messagesRef = db.collection("chats").document(chatId)
            .collection("messages")
        
        messagesRef
            .whereField("senderId", isNotEqualTo: currentUser.id ?? "")
            .whereField("status", isEqualTo: MessageStatus.sent.rawValue)
            .getDocuments { snapshot, error in
                
                if let error = error {
                    print("markDelivered error: \(error.localizedDescription)")
                    return
                }
                
                guard let docs = snapshot?.documents, !docs.isEmpty else {
                    print("markDelivered: no matching docs")
                    return
                }
                
                let batch = self.db.batch()
                for doc in docs {
                    batch.updateData(
                        ["status": MessageStatus.seen.rawValue],
                        forDocument: doc.reference
                    )
                }
                batch.commit()
            }
    }
    
    func markChatAsRead(currentUser: UserModel, otherUser: UserModel) {
        
        let chatId = createChatId(currentUser: currentUser, otherUser: otherUser)
        let docId = "\(chatId)_\(currentUser.id ?? "")"
        
        db.collection("chatUserState")
            .document(docId)
            .setData([
                "chatId": chatId,
                "userId": currentUser.id ?? "",
                "lastReadAt": FieldValue.serverTimestamp()
            ], merge: true)
    }
    
    func deleteChatForMe(currentUser: UserModel, otherUser: UserModel) {

        let chatId: String = createChatId(currentUser: currentUser, otherUser: otherUser)

        let chatRef = db.collection("chats").document(chatId)

        chatRef.updateData([
            "deletedFor": FieldValue.arrayUnion([currentUser.id ?? kEmptyString]),
            "updatedAt": FieldValue.serverTimestamp()
        ]) { error in
            
            if let error = error {
                print("Delete chat error:", error.localizedDescription)
            } else {
                print("Chat deleted for \(currentUser.firstName + " " + currentUser.lastName) only")
            }
        }
    }
    
    private func createChatId(currentUser: UserModel, otherUser: UserModel) -> String {
        let chatId = [currentUser.id ?? "" , otherUser.id ?? ""]
            .sorted()
            .joined(separator: "_")
        return chatId
    }
}
