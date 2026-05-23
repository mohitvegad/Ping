import SwiftUI

import SwiftUI

struct ChatsView: View {
    
    @StateObject var viewModel = ChatsViewModel()
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 0) {
                
                ForEach(viewModel.chats) { chat in
                    NavigationLink {
                        ChatDetailView(userName: chat.userName)
                    } label: {
                        ChatCell(chatModel: chat)

                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .background(Color.black)
        .navigationTitle("Chats")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.black, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        ChatsView()
    }
}
