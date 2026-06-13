import Foundation
import FirebaseFirestore

final class ChatUserStateService: ChatUserStateServiceProtocol {
    
    private let db = Firestore.firestore()

    func createInitialChatState(currentUser: UserModel, otherUser: UserModel) {
        
//        let ref = db.collection("chatUserState")
        let chatId = ChatIdBuilder.build(currentUserId: currentUser.id ?? "", otherUserId: otherUser.id ?? "")

        let currentUserId = currentUser.id ?? ""
        let otherUserId = otherUser.id ?? ""
        
        db.collection("chatUserState")
            .document("\(chatId)_\(currentUserId)")
            .setData([
                "chatId": chatId,
                "userId": currentUserId,
                "unreadCount": 0,
                "lastReadAt": FieldValue.serverTimestamp()
            ])
        
        db.collection("chatUserState")
            .document("\(chatId)_\(otherUserId)")
            .setData([
                "chatId": chatId,
                "userId": otherUserId,
                "unreadCount": 1,
                "lastReadAt": NSNull()
            ])
    }
    
    func fetchChatUserStates(currentUser: UserModel, completion: @escaping ([ChatUserState]) -> Void) {
        db.collection("chatUserState")
            .whereField("userId", isEqualTo: currentUser.id ?? "")
            .addSnapshotListener { snapshot, error in

                guard let docs = snapshot?.documents else {
                    completion([])
                    return
                }

                let states = docs.compactMap {
                    try? $0.data(as: ChatUserState.self)
                }

                completion(states)
            }
    }
    
    func markChatAsRead(currentUser: UserModel, otherUser: UserModel) {
        
        let chatId = ChatIdBuilder.build(currentUserId: currentUser.id ?? "", otherUserId: otherUser.id ?? "")
        let docId = "\(chatId)_\(currentUser.id ?? "")"
        
        db.collection("chatUserState")
            .document(docId)
            .updateData([
                "unreadCount": 0,
                "lastReadAt": FieldValue.serverTimestamp()
            ])
    }
    
    func incrementUnread(currentUser: UserModel, otherUser: UserModel) {
        let chatId = ChatIdBuilder.build(currentUserId: currentUser.id ?? "", otherUserId: otherUser.id ?? "")
        let otherUserId = otherUser.id ?? ""

        let docId = "\(chatId)_\(otherUserId)"

        db.collection("chatUserState")
            .document(docId)
            .updateData([
                "unreadCount": FieldValue.increment(Int64(1))
            ])
    }

   
}
