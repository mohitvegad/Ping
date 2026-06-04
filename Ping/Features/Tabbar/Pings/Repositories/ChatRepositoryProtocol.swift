import Foundation

protocol ChatRepositoryProtocol {
    func sendMessage(text: String, currentUser: UserModel, otherUser: UserModel, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchChats(uid: String, completion: @escaping ([ChatModel]) -> Void)
}
