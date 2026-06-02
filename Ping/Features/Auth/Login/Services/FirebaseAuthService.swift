import FirebaseAuth
import FirebaseFirestore


final class FirebaseAuthService: AuthServiceProtocol {
    
    private let db = Firestore.firestore()

    // MARK: - LOGIN

    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {

        Auth.auth().signIn(withEmail: email, password: password) { result, error in

            if let error {
                completion(.failure(error))
                return
            }

            guard let uid = result?.user.uid else {
                completion(.failure(AuthError.userNotFound))
                return
            }

            completion(.success(uid))
        }
    }

    func getCurrentUser(
        uid: String,
        completion: @escaping (Result<UserModel, Error>) -> Void
    ) {
        db.collection("users")
            .document(uid)
            .getDocument { snapshot, error in

                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let snapshot = snapshot else {
                    completion(.failure(NSError(domain: "Firestore", code: -1)))
                    return
                }

                do {
                    let user = try snapshot.data(as: UserModel.self)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            }
    }
    // MARK: - SIGN UP

    func signUp(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {

        Auth.auth().createUser(withEmail: email, password: password) { result, error in

            if let error {
                completion(.failure(error))
                return
            }

            guard let uid = result?.user.uid else {
                completion(.failure(AuthError.userNotFound))
                return
            }

            completion(.success(uid))
        }
    }

    // MARK: - LOGOUT

    func logout() throws {
        try Auth.auth().signOut()
    }

    // MARK: - CURRENT USER

    func currentUserId() -> String? {
        Auth.auth().currentUser?.uid
    }
}
