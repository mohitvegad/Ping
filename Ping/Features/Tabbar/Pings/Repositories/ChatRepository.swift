import Foundation

final class ChatRepository: ChatRepositoryProtocol {

    private let service: ChatServiceProtocol

    init(service: ChatServiceProtocol) {
        self.service = service
    }

    func getChats(uid: String, completion: @escaping ([ChatModel]) -> Void) {
        service.fetchChats(uid: uid, completion: completion)
    }
    
    func createChat(currentUserId: String, otherUserId: String,completion: @escaping (String) -> Void) {
        service.createChat(currentUserId: currentUserId, otherUserId: otherUserId,completion: completion)
    }
}
