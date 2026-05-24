import Foundation

struct CurrentUser {
    static let id = "1"
}
struct ChatModel: Identifiable {
    let id: String
    let userName: String
    var messages: [MessageModel]
    
    var lastMessage: MessageModel? {
        messages.last
    }

}

extension ChatModel {
    
    static func mock() -> [ChatModel] {
        
        [ChatModel(
            id: UUID().uuidString,
            userName: "User 1",
            messages: [
                MessageModel(id: "1", text: "Hey, How are you? 111111111111111111111", timestamp: Date(), senderId: "11", type: .text, status: .sent), MessageModel(id: "4", text: "I am well, Thank you.", timestamp: Date(), senderId: CurrentUser.id, type: .text, status: .sent)],),
         ChatModel(
            id: UUID().uuidString,
            userName: "User 2",
            messages: [
                MessageModel(id: "2", text: "Hello", timestamp: Date(), senderId: "12", type: .text, status: .sent)]),
         ChatModel(
            id: UUID().uuidString,
            userName: "User 3",
            messages: [
                MessageModel(id: "3", text: "Hey", timestamp: Date(), senderId: "13", type: .text, status: .sent)])]
    }
}
