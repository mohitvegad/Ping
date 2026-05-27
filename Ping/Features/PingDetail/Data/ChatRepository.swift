import Foundation

protocol ChatRepositoryProtocol {
    func sendMessage(userId: String,message: MessageModel)
    func observeMessages(userId: String, completion: @escaping ([MessageModel]) -> Void)
}

final class ChatRepository: ChatRepositoryProtocol {

    private let service: ChatService

    init(service: ChatService) {
        self.service = service
    }

    func sendMessage(userId: String, message: MessageModel) {
        service.sendMessage(userId: userId, message: message)
    }

    func observeMessages(userId: String, completion: @escaping ([MessageModel]) -> Void) {
        service.observeMessages(userId: userId, completion: completion)
    }
}
