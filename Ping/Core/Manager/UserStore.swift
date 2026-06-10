import Foundation
import Combine

protocol UserStoreProtocol {
    func setUsers(_ users: [UserModel])
    func user(id: String) -> UserModel?
    func clear()
}

@MainActor
final class UserStore: UserStoreProtocol, ObservableObject {

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
