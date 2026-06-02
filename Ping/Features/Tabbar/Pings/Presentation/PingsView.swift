import SwiftUI

struct PingsView: View {

    @StateObject private var viewModel: PingsViewViewModel
    @State private var path = NavigationPath()
    @State private var showAddUsersView = false

    var currentUserId: String

    // MARK: - INIT
    init(currentUserId: String) {

        let service = ChatService()
        let repository = ChatRepository(service: service)

        _viewModel = StateObject(
            wrappedValue: PingsViewViewModel(repository: repository)
        )

        self.currentUserId = currentUserId
    }

    // MARK: - BODY
    var body: some View {

        NavigationStack(path: $path) {

            ScrollView {

                VStack(spacing: 0) {

                    ForEach(viewModel.chats) { chat in

                        NavigationLink {
                            openChat(chat: chat)
                        } label: {
                            PingCell(model: chat.toPingCellModel())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .background(Color.black)
            .navigationTitle("Pings")
            .navigationBarTitleDisplayMode(.inline)

            // MARK: - NAVIGATION DESTINATION (for new chats)
            .navigationDestination(for: String.self) { chatId in
                openChatById(chatId: chatId)
            }

            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    ToolbarIconButton(icon: "plus.circle.fill") {
                        showAddUsersView = true
                    }
                }
            }

            // MARK: - SELECT USER FLOW
            .sheet(isPresented: $showAddUsersView) {
                NavigationStack {
                    UsersView(currentUserId: currentUserId) { user in

                        showAddUsersView = false

                        viewModel.createChat(
                            currentUserId: currentUserId,
                            otherUserId: user.id ?? ""
                        ) { chatId in

                            path.append(chatId)
                        }
                    }
                }
            }

            .onAppear {
                viewModel.loadChats(uid: currentUserId)
            }
        }
    }
}

private extension PingsView {

    func openChat(chat: ChatModel) -> some View {

        let currentUser = CurrentUserSession.shared.user!

        let otherUserId = chat.otherUserId(currentUserId: currentUserId)

        let otherUser = UserModel(
            id: otherUserId,
            firstName: "",
            lastName: ""
        )

        return PingDetailView(
            chatId: chat.id ?? "",
            currentUser: currentUser,
            userModel: otherUser,
            repository: ChatRepository(service: ChatService())
        )
    }

    // NavigationPath chatId flow
    func openChatById(chatId: String) -> some View {

        let currentUser = CurrentUserSession.shared.user!

        let otherUserId = chatId.components(separatedBy: "_")
            .first { $0 != currentUser.id } ?? ""

        let otherUser = UserModel(
            id: otherUserId,
            firstName: "",
            lastName: ""
        )

        return PingDetailView(chatId: chatId,currentUser: currentUser,userModel: otherUser, repository: ChatRepository(service: ChatService()))
    }
}
