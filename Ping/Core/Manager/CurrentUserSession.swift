final class CurrentUserSession {

    static let shared = CurrentUserSession()
    
    private init() {}

    var userId: String?
}
