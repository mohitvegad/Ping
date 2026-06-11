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
        
        let chatId: String = createChatId(currentUser: currentUser, otherUser: otherUser)
        
        let chatRef = db.collection("chats").document(chatId)
        
        chatRef.getDocument { snapshot, error in
            
            if snapshot?.exists == false {
                
                // CREATE CHAT ONLY ONCE
                let chatData: [String: Any] = [
                    "id": chatId,
                    "participants": [currentUser.id ?? "", otherUser.id ?? ""],
                    "unreadCount": [
                        currentUser.id ?? "": 0,
                        otherUser.id ?? "": 1
                    ],
                    "deletedFor": [],
                    "lastMessage": text,
                    "updatedAt": FieldValue.serverTimestamp()
                ]
                
                chatRef.setData(chatData)
            } else {
                guard let otherUserId = otherUser.id else { return }
                
                // 2 UPDATE CHAT
                chatRef.updateData([
                    "lastMessage": text,
                    "updatedAt": FieldValue.serverTimestamp(),
                    "unreadCount.\(otherUserId)": FieldValue.increment(Int64(1))
                ])
            }
            
            // SEND MESSAGE
            let messageRef = chatRef.collection("messages").document()
            
            let message = MessageModel(
                id: messageRef.documentID,
                text: text,
                senderId: currentUser.id ?? "",
                timestamp: Date(),
                status: .sent
            )
            Task { @MainActor in
                do {
                    try messageRef.setData(from: message)
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            }
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
                
                // 2. reset unread count
                let chatRef = self.db.collection("chats").document(chatId)

                batch.updateData([
                    "unreadCount.\(currentUser.id ?? "")": 0
                ], forDocument: chatRef)
                batch.commit()
            }
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
