import Foundation
import Combine

final class PingsViewViewModel: ObservableObject {

    @Published var chats: [ChatModel] = []

    private let repository: ChatRepositoryProtocol

    init(repository: ChatRepositoryProtocol) {
        self.repository = repository
    }

    //---------------------------
    // FUNCTION
    //---------------------------
    
    func createChat(currentUserId: String, otherUserId: String, completion: @escaping (String) -> Void) {
        repository.createChat(currentUserId: currentUserId,otherUserId: otherUserId,completion: completion)
    }

    func loadChats(uid: String) {

        repository.getChats(uid: uid) { [weak self] chats in

            DispatchQueue.main.async {
                self?.chats = chats.sorted {
                    $0.updatedAt > $1.updatedAt
                }
            }
        }
    }
}

