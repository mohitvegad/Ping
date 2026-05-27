import SwiftUI

struct PingCell: View {
    
    var user : UserModel?
    
    var body: some View {
        cellView
    }
}

private extension  PingCell {
    
    var cellView: some View {
        HStack(spacing: 12) {
            
            Image(systemName: "person.fill")
                .font(.system(size: 28))
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(.brown)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                
                HStack {
                    
                    Text(user?.userName ?? "")
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Text("")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
                
                HStack {
                    
                    Text("")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Text("1")
                        .font(.caption2.bold())
                        .foregroundStyle(.black)
                        .padding(6)
                        .background(.green)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.black)
    }
}

#Preview {
    PingCell()
}
