import FirebaseFirestore

protocol UserServiceProtocol {
    func fetchUsers(completion: @escaping ([UserModel]) -> Void)
}

final class UserService: UserServiceProtocol {

    private let db = Firestore.firestore()

    func fetchUsers(completion: @escaping ([UserModel]) -> Void) {

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
    }}
