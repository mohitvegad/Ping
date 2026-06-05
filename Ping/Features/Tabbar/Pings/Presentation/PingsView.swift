import SwiftUI

struct PingsView: View {
    
    @State private var path = NavigationPath()
    @State private var showAddUsersView = false
    @StateObject var viewModel: PingsViewViewModel
    let currentUserId: String
    
    //-------------------------------------
    // MARK - INITIALIZATION
    //-------------------------------------
    
    init(currentUserId: String) {
        self.currentUserId = currentUserId
        
        let service = ChatService()
        let repository = ChatRepository(service: service)
        _viewModel = StateObject(wrappedValue: PingsViewViewModel(repository: repository))
    }
    
    //-------------------------------------
    // MARK - VIEW BODY
    //-------------------------------------
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(viewModel.chats) { chat in
                        Button {
                            openChat(chat)
                        } label: {
                            PingCell(model: chat.toPingCellModel())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle("Pings")
            .navigationBarTitleDisplayMode(.inline)
            
            // MARK: - NAVIGATION
            .navigationDestination(for: UserModel.self) { otherUser in
                if let currentUser = CurrentUserSession.shared.user {
                    PingDetailView(currentUser: currentUser, otherUser: otherUser, repository: ChatRepository(
                        service: ChatService()))
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
