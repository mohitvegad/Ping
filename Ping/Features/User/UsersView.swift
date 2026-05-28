import SwiftUI

struct UsersView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText: String = ""
    let onSelectUser: (UserModel) -> Void

    @StateObject private var userViewModel = UsersViewModel()
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            searchBar
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(userViewModel.users) { user in
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
        .navigationTitle("Add Ping")
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
            userViewModel.loadUsers()
        }
    }
}

private extension UsersView {
    
    var searchBar: some View {
        
        HStack(spacing: 10) {
            
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)
            
            TextField("Search users...", text: $searchText)
                .foregroundStyle(.white)
        }
        .padding()
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding()
    }
}

#Preview {
    
    NavigationStack {
        UsersView { user in
               print("Selected user:", user.firstName)
           }
       }
}
