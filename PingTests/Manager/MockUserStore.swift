@testable import Ping

final class MockUserStore: UserStoreProtocol {

    private(set) var storedUsers: [String: UserModel] = [:]

    // MARK: - set users
    func setUsers(_ users: [UserModel]) {
        var dict: [String: UserModel] = [:]

        for user in users {
            if let id = user.id {
                dict[id] = user
            }
        }
        storedUsers = dict
    }

    // MARK: - user
    func user(id: String) -> UserModel? {
        storedUsers[id]
    }

    // MARK: - clear
    func clear() {
        storedUsers.removeAll()
    }
}
