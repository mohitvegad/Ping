import Foundation
import Combine

final class PingsViewViewModel: ObservableObject {

    @Published var chats: [ChatModel] = []
    @Published var pingCells: [PingCellModel] = []
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
        
    func makeCellModel(from chat: ChatModel, currentUserId: String) -> PingCellModel {

        let otherUserId = chat.otherUserId(currentUserId: currentUserId)

        let otherUser = UserStore.shared.user(id: otherUserId)

        return PingCellModel(
            id: chat.id ?? "",
            imageName: "person.fill",
            title: "\(otherUser?.firstName ?? "") \(otherUser?.lastName ?? "")",
            subtitle: chat.lastMessage,
            unreadCount: 0,
            date: chat.updatedAt
        )
    }
    
    func deleteChatForMe(currentUser: UserModel, otherUser: UserModel) {
        repository.deleteChatForMe(currentUser: currentUser, otherUser: otherUser)
    }

}

