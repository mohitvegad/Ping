import Foundation

struct PingModel: Identifiable {
    let id: String
    let userName: String
    var messages: [MessageModel]
    
    var lastMessage: MessageModel? {
        messages.max(by: { $0.timestamp < $1.timestamp })
    }

}

extension PingModel {
    
    static func mock() -> [PingModel] {
        
        [PingModel(
            id: UUID().uuidString,
            userName: "User 1",
            messages: [
                MessageModel(id: "1", text: "Hey, How are you?", timestamp: Date(), senderId: "11", type: .text, status: .sent)]),
         PingModel(
            id: UUID().uuidString,
            userName: "User 2",
            messages: [
                MessageModel(id: "2", text: "Hello", timestamp: Date(), senderId: "12", type: .text, status: .sent)]),
         PingModel(
            id: UUID().uuidString,
            userName: "User 3",
            messages: [
                MessageModel(id: "3", text: "Hey", timestamp: Date(), senderId: "13", type: .text, status: .sent)])]
    }
}
