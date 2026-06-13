import Foundation

protocol ChatServiceProtocol {
    
    func fetchChats(uid: String, completion: @escaping ([ChatModel]) -> Void)
    
    func deleteChatForMe(currentUser: UserModel, otherUser: UserModel)
}
