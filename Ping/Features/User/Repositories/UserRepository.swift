import Foundation

final class UserRepository: UserRepositoryProtocol {

    private let service: UserServiceProtocol

    init(service: UserServiceProtocol) {
        self.service = service
    }

    func getUsers(uid: String, completion: @escaping ([UserModel]) -> Void) {
        service.fetchUsers(uid: uid) { users in

            // BUSINESS LOGIC LAYER
            let filteredUsers = users.filter {
                $0.id != uid
            }
            completion(filteredUsers)
        }
    }
}
