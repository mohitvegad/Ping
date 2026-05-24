import Foundation
import Combine

class PingsViewViewModel: ObservableObject {
    
    @Published var chats: [ChatModel] = []
   
    init() {
        chats = ChatModel.mock()
    }
    
    func unreadCount(for chat: ChatModel) -> Int {
        chat.messages.filter { $0.status != .seen }.count
    }
    
    
}
