import FirebaseAuth


final class FirebaseAuthService: AuthServiceProtocol {

    // MARK: - LOGIN

    func login(
        email: String,
        password: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {

        Auth.auth().signIn(
            withEmail: email,
            password: password
        ) { result, error in

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

    // MARK: - SIGN UP

    func signUp(
        email: String,
        password: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {

        Auth.auth().createUser(
            withEmail: email,
            password: password
        ) { result, error in

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
