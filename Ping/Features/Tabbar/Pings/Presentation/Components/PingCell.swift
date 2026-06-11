import SwiftUI


struct PingCell: View {
    
    let model: PingCellModel
    let configuration: PingCellConfiguration
    
    //-------------------------------------
    // MARK - COMPUTED PROPERY
    //-------------------------------------

    private var imageSize: CGFloat {
        switch configuration.style {
        case .small:
            return 40
            
        case .large:
            return 60
        }
    }
    
    private var titleFont: Font {
        return .headline
    }
    
    private var subtitleFont: Font {
        return .subheadline
    }
    
    
    //-------------------------------------
    // MARK - BODY
    //-------------------------------------

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
                .frame(width: imageSize, height: imageSize)
                .background(.brown)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                
                HStack {
                    Text(model.title)
                        .font(titleFont)
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    if configuration.showsDate {
                        Text(model.date.formattedTime)
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
                
                HStack {
                    Text(model.subtitle)
                        .font(subtitleFont)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    if configuration.showsUnreadCount && model.unreadCount > 0 {
                        Text("\(model.unreadCount)")
                            .font(.caption2.bold())
                            .foregroundStyle(.black)
                            .padding(6)
                            .background(.green)
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.black)
    }
}

