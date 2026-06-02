import Foundation

protocol ChatServiceProtocol {
    func fetchChats(uid: String, completion: @escaping ([ChatModel]) -> Void)
}
