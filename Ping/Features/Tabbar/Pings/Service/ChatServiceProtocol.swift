import Foundation

protocol ChatServiceProtocol {
    func sendMessage(text: String, currentUser: UserModel, otherUser: UserModel, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchChats(uid: String, completion: @escaping ([ChatModel]) -> Void)
    func fetchMessages(currentUser: UserModel, otherUser: UserModel, completion: @escaping ([MessageModel]) -> Void)
    func markMessagesAsSeen(currentUser: UserModel, otherUser: UserModel)
}
