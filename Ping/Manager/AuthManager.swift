import FirebaseAuth

final class AuthManager {

    static let shared = AuthManager()

    func loginAsGuest(completion: @escaping (Bool) -> Void) {

        if let user = Auth.auth().currentUser {
            print("Already logged in:", user.uid)
            completion(true)
            return
        }

        Auth.auth().signInAnonymously { result, error in

            if let error = error {
                print("Guest login failed:", error.localizedDescription)
                completion(false)
                return
            }

            print("Guest login success:", result?.user.uid ?? "")
            completion(true)
        }
    }
}
