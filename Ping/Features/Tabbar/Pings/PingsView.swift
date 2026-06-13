import SwiftUI

struct PingsView: View {
    
    @State private var path = NavigationPath()
    @State private var showAddUsersView = false
    
    @StateObject var viewModel: PingsViewViewModel
    let currentUserId: String
    let container: AppContainer
    
    //-------------------------------------
    // MARK - INITIALIZATION
    //-------------------------------------
    
    init(viewModel: PingsViewViewModel, currentUserId: String, container: AppContainer) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.currentUserId = currentUserId
        self.container = container
    }

    //-------------------------------------
    // MARK - VIEW BODY
    //-------------------------------------
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(viewModel.chats) { chat in
                    let unread = viewModel.unreadCount(for: chat.id ?? kEmptyString)
                    PingCell(model: viewModel.makeCellModel(from: chat, currentUserId: currentUserId, unreadCount: unread), configuration: .chat)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            openChat(chat)
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.black)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            
                            Button(role: .destructive) {
                                guard let currentUser = CurrentUserSession.shared.user else { return }
                                let otherUserId = chat.otherUserId(currentUserId: currentUserId)
                                guard let otherUser = UserStore.shared.user(id: otherUserId) else { return }

                                viewModel.deleteChatForMe(currentUser: currentUser, otherUser: otherUser)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Pings")
            .navigationBarTitleDisplayMode(.inline)
            
            // MARK: - NAVIGATION
            .navigationDestination(for: UserModel.self) { otherUser in
                if let currentUser = CurrentUserSession.shared.user {
                    PingDetailView(currentUser: currentUser, otherUser: otherUser, repository: container.chatRepository)
                }
            }
            
            // MARK: - Toolbar
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ToolbarIconButton(icon: "plus.circle.fill") {
                        showAddUsersView = true
                    }
                }
            }
            
            // MARK: - Users Sheet
            .sheet(isPresented: $showAddUsersView) {
                NavigationStack {
                    UsersView(currentUserId: currentUserId) { selectedUser in
                        showAddUsersView = false
                        path.append(selectedUser)
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadChats(uid: currentUserId)
            guard let currentUser = CurrentUserSession.shared.user else { return }
            viewModel.loadChatStates(currentUser: currentUser)

        }
    }
}

//-------------------------------------
// MARK - EXTENSION
//-------------------------------------

extension PingsView {
    
    private func openChat(_ chat: ChatModel) {
        
        let otherUserId = chat.otherUserId(currentUserId: currentUserId)
        
        guard let otherUser = UserStore.shared.user(id: otherUserId) else { return }
        
        path.append(otherUser)
    }
}
