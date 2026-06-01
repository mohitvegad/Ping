import Foundation
import Combine

final class PingsViewViewModel: ObservableObject {

    @Published var chats: [ChatModel] = []

    private let service = ChatService()

    //---------------------------
    // FUNCTION
    //---------------------------

    func loadChats() {

//        guard let userId = CurrentUserSession.shared.id else { return }
//
//        service.observeChats(userId: userId) { [weak self] chats in
//            DispatchQueue.main.async {
//                self?.chats = chats
//            }
//        }
    }
}
