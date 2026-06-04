import Foundation

final class ChatRepository: ChatRepositoryProtocol {

    private let service: ChatServiceProtocol

    init(service: ChatServiceProtocol) {
        self.service = service
    }
    
    func sendMessage(text: String, currentUser: UserModel, otherUser: UserModel, completion: @escaping (Result<Void, Error>) -> Void) {
        service.sendMessage(text: text, currentUser: currentUser, otherUser: otherUser, completion: completion)
    }

    func fetchChats(uid: String, completion: @escaping ([ChatModel]) -> Void) {
        service.fetchChats(uid: uid, completion: completion)
    }
    
    func fetchMessages(currentUser: UserModel, otherUser: UserModel, completion: @escaping ([MessageModel]) -> Void) {
        service.fetchMessages(currentUser: currentUser, otherUser: otherUser, completion: completion)
    }
    
}
