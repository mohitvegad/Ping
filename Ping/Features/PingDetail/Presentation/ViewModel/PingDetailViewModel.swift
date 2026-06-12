import Foundation
import Combine
import FirebaseFirestore

@MainActor
final class PingDetailViewModel: ObservableObject {

    @Published var messages: [MessageModel] = []

    let currentUser: UserModel
    let otherUser: UserModel
    private let repository: ChatRepositoryProtocol
    
    //---------------------------
    // INITIALIZATION
    //---------------------------
    
    init(currentUser: UserModel, otherUser: UserModel, repository: ChatRepositoryProtocol) {
        self.currentUser = currentUser
        self.otherUser = otherUser
        self.repository = repository

        listenMessages()
    }
}

extension PingDetailViewModel {
    
    func listenMessages() {
        repository.fetchMessages(currentUser: currentUser, otherUser: otherUser) { [weak self] messages in
            guard let self = self else { return }
            self.messages = messages
            self.markAsSeenIfNeeded()
        }
    }
}

extension PingDetailViewModel {
    
    func sendMessage(_ text: String) {

        repository.sendMessage(text: text, currentUser: currentUser, otherUser: otherUser) { result in
            switch result {
            case .success:
                print("Message sent")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func markAsSeenIfNeeded() {
        repository.markMessagesAsSeen(currentUser: currentUser, otherUser: otherUser)
    }
    
    func maskAsChatRead() {
        repository.markChatAsRead(currentUser: currentUser, otherUser: otherUser)
    }
}
