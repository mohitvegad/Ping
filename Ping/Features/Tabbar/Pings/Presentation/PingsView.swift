import SwiftUI

struct PingsView: View {
    
    //---------------------------
    //
    //---------------------------
    
    @StateObject var viewModel = PingsViewViewModel()
    @State private var path = NavigationPath()
    @State private var showAddPingView = false
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(viewModel.chats) { chat in
                        NavigationLink {
                            let user = UserModel(
                                    id: chat.otherUserId,
                                    firstName: chat.otherUserName,
                                    lastName: ""
                                )

                            PingDetailView(userModel: user)
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
                        showAddPingView = true
                    }
                }
            }
            .sheet(isPresented: $showAddPingView) {
                UsersView { user in
                    showAddPingView = false
                    path.append(user)
                }
            }
            // MARK: - NAVIGATION DESTINATION
            .navigationDestination(for: UserModel.self) { user in
                PingDetailView(userModel: user)
            }
            .onAppear {
                viewModel.loadChats()
            }
        }
    }
}

#Preview {
    NavigationStack {
        PingsView()
    }
}
