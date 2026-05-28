import Foundation

protocol ChatRepositoryProtocol {
    func sendMessage(chatId: String, otherUserId: String, message: MessageModel)
    func observeMessages(chatId: String, completion: @escaping ([MessageModel]) -> Void)
}

final class ChatRepository: ChatRepositoryProtocol {

    private let service: ChatService

    init(service: ChatService) {
        self.service = service
    }

    func sendMessage(chatId: String, otherUserId: String, message: MessageModel) {
        service.sendMessage(chatId: chatId, otherUserId: otherUserId, message: message)
    }

    func observeMessages(chatId: String, completion: @escaping ([MessageModel]) -> Void) {
        service.observeMessages(chatId: chatId, completion: completion)
    }
}
