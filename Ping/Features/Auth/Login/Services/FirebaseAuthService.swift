import FirebaseAuth
import FirebaseFirestore


final class FirebaseAuthService: FirebaseAuthServiceProtocol {
    
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
    
    func fetchUsers(uid: String, completion: @escaping ([UserModel]) -> Void) {
        
        db.collection("users")
            .getDocuments { snapshot, error in
                print("Documents count:", snapshot?.documents.count ?? 0)
                snapshot?.documents.forEach {
                    print($0.data())
                }
                let users = snapshot?.documents.compactMap {
                    try? $0.data(as: UserModel.self)
                } ?? []
                
                print("Decoded users:", users.count)
                
                completion(users)
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
