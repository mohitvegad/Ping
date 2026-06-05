import Foundation
import Combine

@MainActor
final class UserStore: ObservableObject {

    static let shared = UserStore()

    @Published private(set) var usersById: [String: UserModel] = [:]

    private init() {}

    // MARK: - ALL USERS
    
    var allUsers: [UserModel] {
        Array(usersById.values)
    }

    
    // MARK: - SET USERS
    func setUsers(_ users: [UserModel]) {
        var dict: [String: UserModel] = [:]
        users.forEach { user in
            if let id = user.id {
                dict[id] = user
            }
        }

        self.usersById = dict
    }

    // MARK: - GET USER
    func user(id: String) -> UserModel? {
        usersById[id]
    }

    // MARK: - CLEAR
    func clear() {
        usersById.removeAll()
    }
}
