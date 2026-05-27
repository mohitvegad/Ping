import Foundation
import FirebaseAuth

final class CurrentUserSession {

    static let shared = CurrentUserSession()

    private init() {}

    var id: String? {
        Auth.auth().currentUser?.uid
    }

    var isLoggedIn: Bool {
        Auth.auth().currentUser != nil
    }
}
