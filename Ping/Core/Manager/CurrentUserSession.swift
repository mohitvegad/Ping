protocol CurrentUserSessionProtocol {
    func setUserId(_ id: String)
    func setUser(_ user: UserModel)
    func clear()
}

final class CurrentUserSession: CurrentUserSessionProtocol {

    static let shared = CurrentUserSession()
    
    private(set) var userId: String?
    private(set) var user: UserModel?

    //---------------------------
    // INITIALIZATION
    //---------------------------

    private init() {}

    //---------------------------
    // Functions
    //---------------------------
    
    func setUserId(_ id: String) {
        self.userId = id
    }

    func setUser(_ user: UserModel) {
        self.user = user
        self.userId = user.id
    }

    func clear() {
        userId = nil
        user = nil
    }
}
