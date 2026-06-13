import Foundation
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
    
    func deleteChatForMe(currentUser: UserModel, otherUser: UserModel) {
        
        let chatId = ChatIdBuilder.build(currentUserId: currentUser.id ?? "", otherUserId: otherUser.id ?? "")
        
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
}
