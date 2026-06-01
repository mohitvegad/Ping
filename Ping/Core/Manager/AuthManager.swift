import FirebaseAuth

final class AuthManager {

    static let shared = AuthManager()

    private let userService: UserServiceProtocol = UserService()

    private init() {}

    func loginAsGuest(completion: @escaping (Bool) -> Void) {

        if let user = Auth.auth().currentUser {
            loadUser(uid: user.uid, completion: completion)
            return
        }

        Auth.auth().signInAnonymously { [weak self] result, error in

            if let error = error {
                print("Guest login failed:", error.localizedDescription)
                completion(false)
                return
            }

            guard let uid = result?.user.uid else {
                completion(false)
                return
            }

            self?.createAndLoadUser(uid: uid, completion: completion)
        }
    }

    private func createAndLoadUser(uid: String, completion: @escaping (Bool) -> Void) {

        print(" Creating user for uid:", uid)

        let newUser = UserModel(
            id: uid,
            firstName: "Guest",
            lastName: "One"
        )

        userService.createUser(user: newUser) { [weak self] success in

            print("User create result:", success)

            guard success else {
                completion(false)
                return
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.loadUser(uid: uid, completion: completion)
            }
        }
    }
    private func loadUser(uid: String, completion: @escaping (Bool) -> Void) {

        userService.fetchCurrentUser(uid: uid) { user in

            guard let user = user else {
                print("User still not found after creation")
                completion(false)
                return
            }

            CurrentUserSession.shared.user = user
            completion(true)
        }
    }
}
