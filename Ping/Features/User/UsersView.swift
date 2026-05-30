import SwiftUI

struct UsersView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: UsersViewModel
    
    var onSelectUser: (UserModel) -> Void
    
    //---------------------------
    // INITIALIZATION
    //---------------------------

    init(onSelectUser: @escaping (UserModel) -> Void) {

        self.onSelectUser = onSelectUser

        _viewModel = StateObject(
            wrappedValue: UsersViewModel(service: UserService())
        )
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
                            PingCell(model: user.toPingCellModel())
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
        .onAppear {
            viewModel.loadUsers()
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
