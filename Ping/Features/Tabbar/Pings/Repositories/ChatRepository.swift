import Foundation

final class ChatRepository: ChatRepositoryProtocol {

    private let service: ChatServiceProtocol

    init(service: ChatServiceProtocol) {
        self.service = service
    }

    func getChats(uid: String, completion: @escaping ([ChatModel]) -> Void) {
        service.fetchChats(uid: uid, completion: completion)
    }
}
