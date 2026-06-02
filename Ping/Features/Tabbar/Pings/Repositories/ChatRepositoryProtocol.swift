import Foundation

protocol ChatRepositoryProtocol {
    func createChat(currentUserId: String, otherUserId: String, completion: @escaping (String) -> Void)
    func getChats(uid: String, completion: @escaping ([ChatModel]) -> Void)
}
