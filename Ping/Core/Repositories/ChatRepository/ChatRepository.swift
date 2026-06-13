import Foundation

final class ChatRepository: ChatRepositoryProtocol {
    
    private let chatService: ChatServiceProtocol
    private let messageService: MessageServiceProtocol
    private let stateService: ChatUserStateServiceProtocol

    init(
        chatService: ChatServiceProtocol,
        messageService: MessageServiceProtocol,
        stateService: ChatUserStateServiceProtocol
    ) {
        self.chatService = chatService
        self.messageService = messageService
        self.stateService = stateService
    }
    
    //MARK: - CHAT SERVICE
    func fetchChats(uid: String, completion: @escaping ([ChatModel]) -> Void) {
        chatService.fetchChats(uid: uid, completion: completion)
    }
    
    func deleteChatForMe(currentUser: UserModel, otherUser: UserModel) {
        chatService.deleteChatForMe(currentUser: currentUser, otherUser: otherUser)
    }

    //MARK: - MESSAGE SERVICE
    func sendMessage(text: String, currentUser: UserModel, otherUser: UserModel, completion: @escaping (Result<Void, Error>) -> Void) {
        
        messageService.sendMessage(text: text, currentUser: currentUser, otherUser: otherUser) { [weak self] result in

                guard let self = self else { return }

                switch result {

                case .success:

                    let chatId = ChatIdBuilder.build(
                        currentUserId: currentUser.id ?? "",
                        otherUserId: otherUser.id ?? ""
                    )

                    // 1. update unread for receiver
                    stateService.incrementUnread(currentUser: currentUser, otherUser: otherUser)

                    completion(.success(()))

                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchMessages(currentUser: UserModel, otherUser: UserModel, completion: @escaping ([MessageModel]) -> Void) {
        messageService.fetchMessages(currentUser: currentUser, otherUser: otherUser, completion: completion)
    }
    
    func markMessagesAsSeen(currentUser: UserModel, otherUser: UserModel) {
        messageService.markMessagesAsSeen(currentUser: currentUser, otherUser: otherUser)
    }
    
    //MARK: - STATE SERVICE
    func fetchChatUserStates(currentUser: UserModel, completion: @escaping ([ChatUserState]) -> Void) {
        stateService.fetchChatUserStates(currentUser: currentUser, completion: completion)
    }
    
    func markChatAsRead(currentUser: UserModel, otherUser: UserModel) {
        stateService.markChatAsRead(currentUser: currentUser, otherUser: otherUser)
    }
    

    
}
