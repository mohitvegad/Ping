final class AppContainer {

    // MARK: - Services
    let chatService: ChatServiceProtocol
    let messageService: MessageServiceProtocol
    let stateService: ChatUserStateServiceProtocol

    // MARK: - Repository
    let chatRepository: ChatRepositoryProtocol

    // MARK: - ViewModels
    let pingsViewModel: PingsViewViewModel

    init() {

        // Services (single source of truth)
        self.chatService = ChatService()
        self.stateService = ChatUserStateService()
        self.messageService = MessageService(stateService: stateService)

        // Repository (composition of services)
        self.chatRepository = ChatRepository(
            chatService: chatService,
            messageService: messageService,
            stateService: stateService
        )

        // ViewModels
        self.pingsViewModel = PingsViewViewModel(
            repository: chatRepository
        )
    }
}
