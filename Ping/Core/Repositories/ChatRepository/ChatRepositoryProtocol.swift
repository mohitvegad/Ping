import Foundation

protocol ChatRepositoryProtocol {
    
    //MARK: - CHAT SERVICE
    
    func fetchChats(uid: String, completion: @escaping ([ChatModel]) -> Void)
    
    func deleteChatForMe(currentUser: UserModel, otherUser: UserModel)

    
    //MARK: - MESSAGE SERVICE
    
    func sendMessage(text: String, currentUser: UserModel, otherUser: UserModel, completion: @escaping (Result<Void, Error>) -> Void)
    
    func fetchMessages(currentUser: UserModel, otherUser: UserModel, completion: @escaping ([MessageModel]) -> Void)
    
    func markMessagesAsSeen(currentUser: UserModel, otherUser: UserModel)
    
    
    //MARK: - STATE SERVICE

    func fetchChatUserStates(currentUser: UserModel, completion: @escaping ([ChatUserState]) -> Void)
    
    func markChatAsRead(currentUser: UserModel, otherUser: UserModel)
}
