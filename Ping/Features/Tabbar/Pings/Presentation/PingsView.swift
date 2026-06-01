import SwiftUI

struct PingsView: View {

    @StateObject var viewModel = PingsViewViewModel()

    @State private var path = NavigationPath()
    @State private var showAddUsersView = false

    var currentUserId: String

    var body: some View {

        NavigationStack(path: $path) {

            ScrollView {

                VStack(spacing: 0) {

                    ForEach(viewModel.chats) { chat in

                        NavigationLink {

                            if let currentUser = CurrentUserSession.shared.user {

                                let otherUserId = chat.otherUserId(currentUserId: currentUserId)

//                                PingDetailView(
//                                    chatId: chat.id ?? "",
//                                    currentUser: currentUser,
//                                    userModel: user
//                                )
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
                viewModel.loadChats()
            }
        }
    }
}
