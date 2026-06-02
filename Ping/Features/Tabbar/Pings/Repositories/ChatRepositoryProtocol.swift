import Foundation

protocol ChatRepositoryProtocol {
    func getChats(uid: String, completion: @escaping ([ChatModel]) -> Void)
}
