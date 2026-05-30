import Foundation
import Combine
import FirebaseFirestore

@MainActor
final class PingDetailViewModel: ObservableObject {

    @Published var messages: [MessageModel] = []

    let userModel: UserModel
    let chatId: String
    private let repository: ChatRepositoryProtocol
    
    //---------------------------
    // INITIALIZATION
    //---------------------------
    
    init(chatId: String, userModel: UserModel, repository: ChatRepositoryProtocol) {
        self.userModel = userModel
        self.repository = repository
        self.chatId =  chatId
        
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
            senderId: CurrentUserSession.shared.id ?? ""
        )

        repository.sendMessage(chatId: chatId, otherUserId: userModel.id ?? "", message: message)
    }
}
