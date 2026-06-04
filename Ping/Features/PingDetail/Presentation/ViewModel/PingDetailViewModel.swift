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
//        repository.observeMessages(chatId: chatId) { [weak self] messages in
//            guard let self else { return }
//            DispatchQueue.main.async {
//                self.messages = messages
//            }
//        }
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
}
