import SwiftUI

struct PingCell: View {
    
    let model: PingCellModel

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
                    
                    Text(model.title)
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Text("")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
                
                HStack {
                    
                    Text(model.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Text("")
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
    PingCell(model: PingCellModel(id: "", title: "", subtitle: "", imageName: ""))
}
