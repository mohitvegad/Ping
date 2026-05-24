import SwiftUI

struct PingsView: View {
    
    @StateObject var viewModel = PingsViewViewModel()
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 0) {
                
                ForEach(viewModel.pings) { ping in
                    NavigationLink {
                        PingDetailView(ping: ping)
                    } label: {
                        PingCell(pingModel: ping)

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
        PingsView()
    }
}
