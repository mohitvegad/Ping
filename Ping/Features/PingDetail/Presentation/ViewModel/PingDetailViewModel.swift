import Foundation
import Combine
import FirebaseFirestore

@MainActor
final class PingDetailViewModel: ObservableObject {

    @Published var messages: [MessageModel] = []

    let currentUser: UserModel
    let userModel: UserModel
    let chatId: String
    private let repository: ChatRepositoryProtocol
    
    //---------------------------
    // INITIALIZATION
    //---------------------------
    
    init(currentUser: UserModel, userModel: UserModel, chatId: String, repository: ChatRepositoryProtocol) {
        self.currentUser = currentUser
        self.userModel = userModel
        self.chatId = chatId
        self.repository = repository

        listenMessages()
    }
}

extension PingDetailViewModel {

    func listenMessages() {
        repository.observeMessages(chatId: chatId) { [weak self] messages in
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
            senderId: currentUser.id ?? ""
        )

        repository.sendMessage(
            chatId: chatId,
            currentUser: currentUser,
            otherUser: userModel,
            message: message
        )
    }
}
