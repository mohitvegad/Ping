import Foundation
import Combine
import FirebaseFirestore

@MainActor
final class PingDetailViewModel: ObservableObject {

    @Published var messages: [MessageModel] = []

    let chat: ChatModel
    private let repository: ChatRepositoryProtocol
    

    init(chat: ChatModel, repository: ChatRepositoryProtocol) {
        self.chat = chat
        self.repository = repository
        listenMessages()
    }

}

extension PingDetailViewModel {

    func listenMessages() {
        repository.observeMessages(chatId: chat.id) { [weak self] messages in
            guard let self else { return }
            DispatchQueue.main.async {
                self.messages = messages
            }
        }
    }
}


extension PingDetailViewModel {

    func sendMessage(_ text: String) {

        let message = MessageModel(
            id: UUID().uuidString,
            text: text,
            timestamp: Date(),
            senderId: CurrentUserSession.shared.id ?? "",
            type: .text,
            status: .sent
        )

        repository.sendMessage(chatId: chat.id, message: message)
    }
}
