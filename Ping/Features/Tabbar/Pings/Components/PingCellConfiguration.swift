import Foundation

enum PingCellStyle {
    case small
    case large
}

struct PingCellConfiguration {

    let style: PingCellStyle

    let showsDate: Bool
    let showsUnreadCount: Bool
}

extension PingCellConfiguration {

    static let chat = Self(style: .large, showsDate: true, showsUnreadCount: true)

    static let user = Self(style: .small, showsDate: false, showsUnreadCount: false)
}
