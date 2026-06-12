import FirebaseAuth
import FirebaseFirestore
import os.log

final class FirebaseAuthService: FirebaseAuthServiceProtocol {
    
    private let db = Firestore.firestore()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "FirebaseAuthService")

    //---------------------------
    // Function
    //---------------------------

    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {

        Auth.auth().signIn(withEmail: email, password: password) { result, error in

            if let error {
                self.dispatchToMain { completion(.failure(error)) }
                return
            }

            guard let uid = result?.user.uid else {
                self.dispatchToMain { completion(.failure(AuthError.userNotFound)) }
                return
            }

            self.dispatchToMain { completion(.success(uid)) }
        }
    }
    
    func fetchUsers(completion: @escaping (Result<[UserModel], Error>) -> Void) {
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                self.dispatchToMain { completion(.failure(error)) }
                return
            }
            
            guard let snapshot = snapshot else {
                #if DEBUG
                self.logger.error("fetchUsers: Received nil snapshot without error.")
                #endif
                self.dispatchToMain { completion(.failure(NSError(domain: "FirebaseAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected nil snapshot"])) ) }
                return
            }
            
            var users: [UserModel] = []
            users.reserveCapacity(snapshot.documents.count)
            
            for doc in snapshot.documents {
                do {
                    let user = try doc.data(as: UserModel.self)
                    users.append(user)
                } catch {
                    #if DEBUG
                    self.logger.error("Decoding UserModel failed for docID=\(doc.documentID, privacy: .public): \(error.localizedDescription, privacy: .public)")
                    #endif
                    // Intentionally continue with partial results.
                }
            }
            
            self.dispatchToMain { completion(.success(users)) }
        }
    }

    func logout() throws {
        try Auth.auth().signOut()
    }

    func currentUserId() -> String? {
        Auth.auth().currentUser?.uid
    }
    
    // MARK: - Helpers
    private func dispatchToMain(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(execute: block)
        }
    }
}
