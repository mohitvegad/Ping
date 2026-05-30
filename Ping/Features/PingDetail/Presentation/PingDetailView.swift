import SwiftUI
import FirebaseAuth

enum InputState {
    case idle
    case typing
}

struct PingDetailView: View {
    
    var userModel: UserModel?
    var isOnline: Bool = false
    var imageURL: String? = nil
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: PingDetailViewModel
    @State private var inputText: String = ""
    
    var inputState: InputState {
        inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .idle : .typing
    }
    
    //---------------------------
    // INITIALIZATION
    //---------------------------
    
    init(chatId: String, userModel: UserModel) {
        self.userModel = userModel
        _viewModel = StateObject(
            wrappedValue: PingDetailViewModel(chatId: chatId, userModel: userModel, repository: ChatRepository(service: ChatService()))
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            headerView
            
            messagesView
            
            inputView
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .toolbar(.hidden, for: .tabBar)
    }
}
private extension PingDetailView {
    
    var headerView: some View {
        HStack(spacing: 12) {
            
            // MARK: Back Button
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
            }
            
            // MARK: Profile Image
            Image(systemName: "person.fill")
                .font(.system(size: 28))
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(.brown)
                .clipShape(Circle())
            
            // MARK: Name + Status
            VStack(alignment: .leading, spacing: 2) {
                
                Text("")
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Text(isOnline ? "Online" : "Last seen recently")
                    .font(.caption)
                    .foregroundStyle(isOnline ? .green : .gray)
            }
            
            Spacer()
            
            // MARK: Actions
            HStack(spacing: 18) {
                
                Button {
                    // voice call
                } label: {
                    Image(systemName: "phone")
                        .foregroundStyle(.white)
                }
                
                Button {
                    // video call
                } label: {
                    Image(systemName: "video")
                        .foregroundStyle(.white)
                }
                
                Button {
                    // info
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundStyle(.white)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color.black.opacity(0.95))
        .toolbar(.hidden, for: .navigationBar)
        
    }
}

private extension PingDetailView {
    
    var messagesView: some View {
        
        ScrollView {
            
            VStack(spacing: 12) {
                
                ForEach(viewModel.messages) { message in
                    let isMe = message.senderId == CurrentUserSession.shared.id ?? "unknown"
                    
                    HStack {
                        Text(message.text)
                            .padding(10)
                            .background(Color.gray.opacity(0.3))
                            .foregroundStyle(.white)
                            .cornerRadius(10)
                            .frame(maxWidth: 280, alignment: isMe ? .trailing : .leading)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: isMe ? .trailing : .leading)
                }
            }
            .padding(.top, 10)
        }
    }
}

private extension PingDetailView {
    
    var inputView: some View {
        
        HStack(spacing: 12) {
            
            Button {
                
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 24))
                    .foregroundStyle(.white)
            }
            
            TextField("Type a message...", text: $inputText)
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .clipShape(.capsule)
                .foregroundStyle(.white)
            
            switch inputState {
                
            case .idle:
                Button {
                    // camera action
                } label: {
                    Image(systemName: "camera")
                        .font(.system(size: 24))
                        .foregroundStyle(.white)
                }
                
                Button {
                    // mic action
                } label: {
                    Image(systemName: "mic")
                        .font(.system(size: 24))
                        .foregroundStyle(.white)
                }
                
            case .typing:
                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.white)
                }
            }
        }
        .padding()
        .background(Color.black)
        
    }
}

private extension PingDetailView {
    
    func sendMessage() {
        guard !inputText.isEmpty else { return }
        viewModel.sendMessage(inputText)
        inputText = ""
    }
}

#Preview {
//    PingDetailView()
}

