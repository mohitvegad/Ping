import Foundation
import Combine

final class PingsViewViewModel: ObservableObject {

    @Published var chats: [ChatModel] = []

    private let repository: ChatRepositoryProtocol

    //-------------------------------------
    // MARK - INITIALIZATION
    //-------------------------------------

    init(repository: ChatRepositoryProtocol) {
        self.repository = repository
    }

    //---------------------------
    // FUNCTION
    //---------------------------

    func loadChats(uid: String) {
        repository.fetchChats(uid: uid) { [weak self] chats in
            DispatchQueue.main.async {
                self?.chats = chats.sorted {
                    $0.updatedAt > $1.updatedAt
                }
            }
        }
    }
    
    func deleteChatForMe(currentUser: UserModel, otherUser: UserModel) {
        repository.deleteChatForMe(currentUser: currentUser, otherUser: otherUser)
    }
}

