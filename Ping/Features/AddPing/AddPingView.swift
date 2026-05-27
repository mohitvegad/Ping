import SwiftUI

struct AddPingView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText: String = ""
    let onSelectUser: (ChatModel) -> Void
    
    let users: [ChatModel] = [
        
        ChatModel(
            id: "1",
            userId: "user_1",
            userName: "Harry",
            lastMessage: "Hey 👋",
            updatedAt: Date()
        ),
        
        ChatModel(
            id: "2",
            userId: "user_2",
            userName: "Olivia",
            lastMessage: "Let's catch up",
            updatedAt: Date()
        ),
        
        ChatModel(
            id: "3",
            userId: "user_3",
            userName: "Jack",
            lastMessage: "Ping me later",
            updatedAt: Date()
        )
    ]
    var filteredUsers: [ChatModel] {
        
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
                            PingCell(chatModel: user)
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
