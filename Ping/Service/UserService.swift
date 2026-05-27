import FirebaseFirestore

final class UserService {

    private let db = Firestore.firestore()

    func fetchUsers(completion: @escaping ([UserModel]) -> Void) {

        db.collection("users")
            .getDocuments { snapshot, _ in

                let users = snapshot?.documents.compactMap {
                    try? $0.data(as: UserModel.self)
                } ?? []

                completion(users)
            }
    }
}


final class UserSeeder {

    private let db = Firestore.firestore()

    func seedUsers() {

        let users: [UserModel] = [
            .init(id: "user_1", userName: "Harry"),
            .init(id: "user_2", userName: "Olivia"),
            .init(id: "user_3", userName: "Jack"),
            .init(id: "user_4", userName: "Emma"),
            .init(id: "user_5", userName: "Noah")
        ]

        for user in users {
            try? db.collection("users")
                .document(user.id)
                .setData(from: user)
        }
    }
}
