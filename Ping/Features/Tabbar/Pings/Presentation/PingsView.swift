import SwiftUI

struct PingsView: View {

    @StateObject var viewModel = PingsViewViewModel()
    @State private var path = NavigationPath()
    @State private var showAddUsersView = false

    var body: some View {
        NavigationStack(path: $path) {

            ScrollView {
                VStack(spacing: 0) {

                    ForEach(viewModel.chats) { chat in

                        NavigationLink {

//                            let currentUserId = CurrentUserSession.shared.id ?? ""
                            let currentUserId = "CurrentUserSession.shared.id ?? "


                            let otherUserId = chat.otherUserId(currentUserId: currentUserId)

                            let user = UserModel(
                                id: otherUserId,
                                firstName: "",
                                lastName: ""
                            )

//                            if let currentUser = CurrentUserSession.shared.user {
//
//                                PingDetailView(
//                                    chatId: chat.id ?? "",
//                                    currentUser: currentUser,
//                                    userModel: user,
//                                    repository: ChatRepository(service: ChatService())
//                                )
//                            }

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
            .toolbarBackground(.black, for: .navigationBar)

            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    ToolbarIconButton(icon: "plus.circle.fill") {
                        showAddUsersView = true
                    }
                }
            }

            .sheet(isPresented: $showAddUsersView) {
                NavigationStack {
                    UsersView { user in
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
