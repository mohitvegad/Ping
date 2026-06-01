import Foundation
import FirebaseAuth

final class CurrentUserSession {

    //---------------------------
    // Singlton
    //---------------------------
    
    static let shared = CurrentUserSession()

    var user: UserModel?

    private init() {}

    //---------------------------
    // Computed Property
    //---------------------------
    
    var id: String? {
        Auth.auth().currentUser?.uid
    }

    var isLoggedIn: Bool {
        Auth.auth().currentUser != nil
    }
}
