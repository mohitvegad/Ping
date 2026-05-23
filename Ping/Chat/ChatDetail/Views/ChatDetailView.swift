import SwiftUI


struct ChatDetailView: View {
    
    var userName: String = ""
    var isOnline: Bool = false
    var imageURL: String? = nil
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        headerView
    }
}
private extension ChatDetailView {
    
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
                
                Text(userName)
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

    }
}

#Preview {
    ChatDetailView()
}

