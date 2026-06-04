import SwiftUI

struct PingDetailView: View {

    let chatId: String
    let currentUser: UserModel
    let otherUser: UserModel

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: PingDetailViewModel
    @State var inputText: String = ""

    //---------------------------
    // INITIALIZATION
    //---------------------------
    
    init(chatId: String, currentUser: UserModel, otherUser: UserModel, repository: ChatRepositoryProtocol) {
        self.chatId = chatId
        self.currentUser = currentUser
        self.otherUser = otherUser

        _viewModel = StateObject(wrappedValue: PingDetailViewModel(currentUser: currentUser, otherUser: otherUser,
                chatId: chatId,repository: repository))
    }

    // MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {

            headerView

            messagesView

            inputView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .navigationBarBackButtonHidden(true)
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
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
            }

            Image(systemName: "person.fill")
                .font(.system(size: 28))
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(Color.gray)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {

                Text("\(otherUser.firstName) \(otherUser.lastName)")
                    .font(.headline)
                    .foregroundStyle(.white)

                Text("Online")
                    .font(.caption)
                    .foregroundStyle(.green)
            }

            Spacer()
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

        ScrollView {

            VStack(spacing: 12) {

                ForEach(viewModel.messages) { message in

                    let isMe = message.senderId == currentUser.id

                    HStack {

                        if isMe { Spacer() }

                        Text(message.text)
                            .padding(10)
                            .background(
                                isMe
                                ? Color.blue
                                : Color.gray.opacity(0.3)
                            )
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                            .frame(maxWidth: 250,
                                   alignment: isMe ? .trailing : .leading)

                        if !isMe { Spacer() }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top, 10)
        }
    }
}

// MARK: - INPUT
private extension PingDetailView {

    var inputView: some View {

        HStack(spacing: 12) {

            TextField("Type a message...", text: $inputText)
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .clipShape(Capsule())
                .foregroundStyle(.white)

            Button {
                sendMessage()
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
            }
            .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
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
    }
}
