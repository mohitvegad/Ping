import Foundation

enum ChatIdBuilder {
    
    static func build(currentUserId: String, otherUserId: String) -> String {
        [currentUserId, otherUserId].sorted().joined(separator: "_")
    }
}
