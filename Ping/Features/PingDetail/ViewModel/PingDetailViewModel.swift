import Foundation
import Combine

final class PingDetailViewModel: ObservableObject {
    
    @Published var ping: PingModel
    
    init(ping: PingModel) {
        self.ping = ping
    }
    
    func sendMessage(_ text: String) {
        
        let message = MessageModel(
            id: UUID().uuidString,
            text: text,
            timestamp: Date(),
            senderId: "me",
            type: .text,
            status: .sending
        )
        
        ping.messages.append(message)
    }
}
