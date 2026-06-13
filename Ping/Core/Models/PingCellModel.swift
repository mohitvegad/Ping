import Foundation

struct PingCellModel: Identifiable, Hashable {

    let id: String
    let imageName: String
    let title: String
    let subtitle: String
    let unreadCount: Int
    let date: Date
}
