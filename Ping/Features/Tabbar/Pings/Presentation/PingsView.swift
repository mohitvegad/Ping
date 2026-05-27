import SwiftUI

struct PingsView: View {
    
    @StateObject var viewModel = PingsViewViewModel()
    @State private var path = NavigationPath()
    @State private var showAddPingView = false
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(viewModel.users) { user in
                        NavigationLink {
                            PingDetailView(user: user)
                        } label: {
                            PingCell(user: user)
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
                PingDetailView(user: user)
            }
        }
    }
}

#Preview {
    NavigationStack {
        PingsView()
    }
}
