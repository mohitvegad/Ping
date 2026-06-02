import Foundation

protocol ChatServiceProtocol {
    func createChat(currentUserId: String, otherUserId: String,completion: @escaping (String) -> Void)
    func fetchChats(uid: String, completion: @escaping ([ChatModel]) -> Void)
}
