import FirebaseFirestore


final class UserService: UserServiceProtocol {
    
    private let db = Firestore.firestore()

//    func createUser(user: UserModel, completion: @escaping (Bool) -> Void) {
//
//        guard let uid = user.id else {
//            completion(false)
//            return
//        }
//
//        db.collection("users")
//            .document(uid)
//            .setData([
//                "firstName": user.firstName,
//                "lastName": user.lastName
//            ]) { error in
//
//                if let error = error {
//                    print("User creation failed:", error.localizedDescription)
//                    completion(false)
//                    return
//                }
//
//                print("User created successfully")
//                completion(true)
//            }
//    }
    
    func fetchCurrentUser(uid: String, completion: @escaping (UserModel?) -> Void) {
        db.collection("users")
            .document(uid)
            .getDocument { snapshot, _ in
                let user = try? snapshot?.data(as: UserModel.self)
                completion(user)
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
    
    
}
