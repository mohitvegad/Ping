import SwiftUI

struct ChatsView: View {
    
    @StateObject var viewModel = ChatsViewModel()

    var body: some View {

        ZStack {

            Color.black.ignoresSafeArea()

            ScrollView(.vertical) {
                VStack {
                    ForEach(viewModel.chats) { chat  in
                        ChatCell(chatModel: chat)
                    }
                }
            }
        }
    }
}
#Preview {
    ChatsView()
}
