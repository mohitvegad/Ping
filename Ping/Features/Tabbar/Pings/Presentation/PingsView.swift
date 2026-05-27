import SwiftUI

struct PingsView: View {
    
    @StateObject var viewModel = PingsViewViewModel()
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 0) {
                
                ForEach(viewModel.chats) { chat in
                    NavigationLink {
                        PingDetailView(chat: chat)
                    } label: {
                        PingCell(chatModel: chat)

                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .background(Color.black)
        .navigationTitle("Pings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.black, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        PingsView()
    }
}
