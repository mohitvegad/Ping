import SwiftUI

struct PingsView: View {

    @StateObject private var viewModel: PingsViewViewModel

    @State private var path = NavigationPath()
    @State private var showAddUsersView = false

    var currentUserId: String

    //---------------------------
    // INIT
    //---------------------------

    init(currentUserId: String) {

        let service = ChatService()
        let repository = ChatRepository(service: service)

        _viewModel = StateObject(
            wrappedValue: PingsViewViewModel(repository: repository)
        )

        self.currentUserId = currentUserId
    }

    var body: some View {

        NavigationStack(path: $path) {

            ScrollView {

                VStack(spacing: 0) {

                    ForEach(viewModel.chats) { chat in

                        NavigationLink {

                            if let currentUser = CurrentUserSession.shared.user {

                                let otherUserId = chat.otherUserId(currentUserId: currentUserId)
                                // NEXT STEP (CHAT DETAIL)
                                // PingDetailView(...)
                            }

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

            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    ToolbarIconButton(icon: "plus.circle.fill") {
                        showAddUsersView = true
                    }
                }
            }

            .sheet(isPresented: $showAddUsersView) {
                NavigationStack {
                    UsersView(currentUserId: currentUserId) { user in
                        showAddUsersView = false
                        path.append(user)
                    }
                }
            }

            .onAppear {
                viewModel.loadChats(uid: currentUserId)
            }
        }
    }
}
