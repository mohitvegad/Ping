import Foundation
import FirebaseFirestore

final class MessageService: MessageServiceProtocol {
    
    private let db = Firestore.firestore()

    private let stateService: ChatUserStateServiceProtocol

    init(stateService: ChatUserStateServiceProtocol) {
        self.stateService = stateService
    }

    //MARK: - MESSAGE SERVICE
    
    func sendMessage(text: String, currentUser: UserModel, otherUser: UserModel, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let chatId = ChatIdBuilder.build(currentUserId: currentUser.id ?? "", otherUserId: otherUser.id ?? "")
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
                
                self.stateService.createInitialChatState(
                      currentUser: currentUser,
                      otherUser: otherUser
                  )
                
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
        
        let chatId = ChatIdBuilder.build(currentUserId: currentUser.id ?? "", otherUserId: otherUser.id ?? "")
        
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
        
        let chatId = ChatIdBuilder.build(currentUserId: currentUser.id ?? "", otherUserId: otherUser.id ?? "")
        
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
    

}
