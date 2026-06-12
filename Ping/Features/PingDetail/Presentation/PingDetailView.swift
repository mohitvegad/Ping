import SwiftUI

struct PingDetailView: View {
    
    let currentUser: UserModel
    let otherUser: UserModel
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: PingDetailViewModel
    @State var inputText: String = ""
    @State private var isAtBottom: Bool = true
    @State private var scrollTrigger: UUID = UUID()
    
    //---------------------------
    // Computed Property
    //---------------------------

    var isTyping: Bool {
        !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    //---------------------------
    // INITIALIZATION
    //---------------------------
    
    init(currentUser: UserModel, otherUser: UserModel, repository: ChatRepositoryProtocol) {
        self.currentUser = currentUser
        self.otherUser = otherUser
        
        _viewModel = StateObject(wrappedValue: PingDetailViewModel(currentUser: currentUser, otherUser: otherUser, repository: repository))
    }
    
    //---------------------------
    // BODY
    //---------------------------

    var body: some View {
        VStack(spacing: 0) {
            
            headerView
            
            messagesView
            
            inputView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.maskAsChatRead()
        }
    }
}

// MARK: - HEADER
private extension PingDetailView {
    
    var headerView: some View {
        HStack(spacing: 12) {
            
            Button {
                dismiss()   
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.white)
            }
            
            Image(systemName: "person.fill")
                .font(.system(size: 28))
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(Color.brown)
                .clipShape(Circle())
            
            // MARK: - NAME
            
            VStack(alignment: .leading, spacing: 2) {
                
                Text("\(otherUser.firstName) \(otherUser.lastName)")
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Text("Online")
                    .font(.caption)
                    .foregroundStyle(.green)
            }
            
            Spacer()
            
            // MARK: - Actions
            
            HStack(spacing: 20) {
                
                // Video Call
                Button {
                    
                } label: {
                    Image(systemName: "video")
                        .font(.system(size: 24))
                        .foregroundStyle(.white)
                }
                
                // Audio Call
                Button {
                    
                } label: {
                    Image(systemName: "phone")
                        .font(.system(size: 24))
                        .foregroundStyle(.white)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color.black.opacity(0.95))
        .toolbar(.hidden, for: .tabBar)
    }
}

// MARK: - MESSAGES
private extension PingDetailView {
    
    var messagesView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.messages) { message in
                        
                        let isMe = message.senderId == currentUser.id
                        let isLast = message.id == viewModel.messages.last?.id

                        MessageBubble(message: message, isMe: isMe)
                        .id(message.id)
                        
                        .onAppear {
                            if isLast { isAtBottom = true }
                        }
                        .onDisappear {
                            if isLast { isAtBottom = false }
                        }
                    }
                }
                .padding(.top, 10)
            }
            
            // Open at bottom
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    proxy.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                }
            }
            
            // New message received
            .onChange(of: viewModel.messages.count) { _, _ in
                if isAtBottom {
                    withAnimation(.easeOut(duration: 0.2)) {
                        proxy.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                    }
                }
            }
            
            // user sent a message
            .onChange(of: scrollTrigger) { _, _ in
                withAnimation(.easeOut(duration: 0.2)) {
                    proxy.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                }
            }
        }
    }
}

struct MessageBubble: View {
    
    let message: MessageModel
    let isMe: Bool
    
    var body: some View {
        HStack {
            if isMe { Spacer(minLength: 40) }
            
            HStack(alignment: .bottom, spacing: 6) {
                Text(message.text)
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack(alignment: .bottom, spacing: 3) {
                    Text(message.timestamp.formattedTime)
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.6))
                    
                    if isMe { statusIcon }
                }
            }
            .padding(10)
            .background(isMe ? Color("PingSendBubble") : Color("PingReceiveBubble"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .frame(maxWidth: 250, alignment: isMe ? .trailing : .leading)
            
            if !isMe { Spacer(minLength: 40) }
        }
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    private var statusIcon: some View {
        switch message.status {
        case .sending:
            Image(systemName: "clock")
                .font(.caption2)
                .foregroundStyle(.gray)
        case .sent:
            Image(systemName: "checkmark")
                .font(.caption2)
                .foregroundStyle(.gray)
        case .delivered:
            HStack(spacing: -8) {
                Image(systemName: "checkmark")
                Image(systemName: "checkmark")
            }
            .font(.caption2)
            .foregroundStyle(.gray)
        case .seen:
            HStack(spacing: -8) {
                Image(systemName: "checkmark")
                Image(systemName: "checkmark")
            }
            .font(.caption2)
            .foregroundStyle(.blue)
        }
    }
}


// MARK: - INPUT
private extension PingDetailView {
    
    var inputView: some View {
        
        HStack(spacing: 10) {
            
            // MARK: - PLUS (left)
            Button {
                
                // add attachment
                
            } label: {
                
                Image(systemName: "plus")
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
            }
            
            // MARK: - TEXT FIELD
            TextField("Type a message...", text: $inputText)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(Color.gray.opacity(0.2))
                .clipShape(Capsule())
                .foregroundStyle(.white)
            
            // MARK: - RIGHT SIDE (STATE BASED)
            if isTyping {
                // SEND BUTTON
                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(.white)
                        .frame(width: 36, height: 36)
                        .background(Color.blue)
                    .clipShape(Circle())                }
            } else {
                
                // CAMERA
                Button {
                    
                    // camera action
                    
                } label: {
                    
                    Image(systemName: "camera.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                }
                
                // MIC
                Button {
                    
                    // mic action
                    
                } label: {
                    
                    Image(systemName: "mic.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.black)
    }
}
// MARK: - ACTION
private extension PingDetailView {
    
    func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        viewModel.sendMessage(text)
        inputText = ""
        scrollTrigger = UUID()
    }
}
