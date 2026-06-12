import SwiftUI

struct UsersView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = UsersViewModel()

    var currentUserId: String
    var onSelectUser: (UserModel) -> Void

    //---------------------------
    // INITIALIZATION
    //---------------------------

    init(currentUserId: String, onSelectUser: @escaping (UserModel) -> Void) {
        self.currentUserId = currentUserId
        self.onSelectUser = onSelectUser
    }

    var body: some View {

        VStack(spacing: 0) {

            searchBar

            ScrollView {
                VStack(spacing: 0) {

                    ForEach(viewModel.filteredUsers) { user in
                        Button {
                            onSelectUser(user)
                            dismiss()
                        } label: {
                            PingCell(model: viewModel.makeCellModel(from: user), configuration: .user)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
        .navigationTitle("New Ping")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Close") {
                    dismiss()
                }
                .foregroundStyle(.white)
            }
        }
    }
}

private extension UsersView {
    
    var searchBar: some View {
        
        HStack(spacing: 10) {
            
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)
            
            TextField("Search users...", text: $viewModel.searchText)
                .foregroundStyle(.white)
        }
        .padding()
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding()
    }
}
