import SwiftUI

struct AddPingView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText: String = ""
    let onSelectUser: (UserModel) -> Void
    let service = UserService()

    
    @State private var users: [UserModel] = []
    
    var filteredUsers: [UserModel] {
        
        if searchText.isEmpty {
            return users
        }
        
        return users.filter {
            $0.userName.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            searchBar
            
            ScrollView {
                
                VStack(spacing: 0) {
                    
                    ForEach(filteredUsers) { user in
                        
                        Button {
                            onSelectUser(user)
                            dismiss()
                        } label: {
                            PingCell(user: user)
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
            service.fetchUsers { users in
                self.users = users
            }
        }
    }
}

private extension AddPingView {
    
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
           AddPingView { user in
               print("Selected user:", user.userName)
           }
       }
}
