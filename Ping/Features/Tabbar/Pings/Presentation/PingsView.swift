import SwiftUI

struct PingsView: View {

    // MARK: - Properties
    @State private var path = NavigationPath()
    @State private var showAddUsersView = false

    let currentUserId: String

    // MARK: - Body
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Text("Pings")
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)

            // MARK: - NAVIGATION
            .navigationDestination(for: UserModel.self) { otherUser in
                if let currentUser = CurrentUserSession.shared.user {
                    PingDetailView(chatId: "", currentUser: currentUser, otherUser: otherUser, repository: ChatRepository(
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
    }
}
