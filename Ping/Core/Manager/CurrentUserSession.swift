final class CurrentUserSession {

    static let shared = CurrentUserSession()
    private init() {}

    // MARK: - Stored in memory
    private(set) var userId: String?

    private(set) var user: UserModel?

    // MARK: - SET SESSION
    func setUserId(_ id: String) {
        self.userId = id
    }

    func setUser(_ user: UserModel) {
        self.user = user
        self.userId = user.id
    }

    // MARK: - CLEAR SESSION
    func clear() {
        userId = nil
        user = nil
    }
}
