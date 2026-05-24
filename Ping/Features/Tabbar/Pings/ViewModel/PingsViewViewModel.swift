import Foundation
import Combine

class PingsViewViewModel: ObservableObject {
    
    @Published var pings: [PingModel] = []
   
    init() {
        pings = PingModel.mock()
    }
    
    func unreadCount(for ping: PingModel) -> Int {
        ping.messages.filter { $0.status != .seen }.count
    }
    
    
}
