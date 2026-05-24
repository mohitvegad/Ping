import Foundation
import Combine

final class PingDetailViewModel: ObservableObject {
    
    @Published var chat: ChatModel
    
    init(chat: ChatModel) {
        self.chat = chat
    }
    
    func sendMessage(_ text: String) {
        
        let message = MessageModel(
            id: UUID().uuidString,
            text: text,
            timestamp: Date(),
            senderId: CurrentUser.id,
            type: .text,
            status: .sending
        )
        
        chat.messages.append(message)
    }
}
