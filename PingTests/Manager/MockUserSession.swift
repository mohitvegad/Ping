@testable import Ping

final class MockUserSession: CurrentUserSessionProtocol {

    var userId: String?
    var user: UserModel?

    // MARK: - set userId
    func setUserId(_ id: String) {
        userId = id
    }

    // MARK: - set users
    func setUser(_ user: UserModel) {
        self.user = user
    }

    // MARK: - clear
    func clear() {
        userId = nil
        user = nil
    }
}
