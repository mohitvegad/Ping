import FirebaseFirestore


final class UserService: UserServiceProtocol {
    
    private let db = Firestore.firestore()

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
