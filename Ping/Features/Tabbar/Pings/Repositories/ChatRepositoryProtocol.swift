import Foundation

protocol ChatRepositoryProtocol {
    
    func fetchChats(uid: String, completion: @escaping ([ChatModel]) -> Void)
    
    func sendMessage(text: String, currentUser: UserModel, otherUser: UserModel, completion: @escaping (Result<Void, Error>) -> Void)
    
    func fetchMessages(currentUser: UserModel, otherUser: UserModel, completion: @escaping ([MessageModel]) -> Void)
    
    func markMessagesAsSeen(currentUser: UserModel, otherUser: UserModel)
    
    func markChatAsRead(currentUser: UserModel, otherUser: UserModel)
    
    func deleteChatForMe(currentUser: UserModel, otherUser: UserModel)
}
