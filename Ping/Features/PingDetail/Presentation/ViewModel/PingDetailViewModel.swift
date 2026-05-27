import Foundation
import Combine
import FirebaseFirestore

@MainActor
final class PingDetailViewModel: ObservableObject {

    @Published var messages: [MessageModel] = []

    let user: UserModel
    private let repository: ChatRepositoryProtocol
    

    init(user: UserModel, repository: ChatRepositoryProtocol) {
        self.user = user
        self.repository = repository
        listenMessages()
    }

}

extension PingDetailViewModel {

    func listenMessages() {
        repository.observeMessages(chatId: user.id) { [weak self] messages in
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
