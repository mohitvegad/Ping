import Foundation

//---------------------------
// Struct
//---------------------------

struct UsersResult {
    let currentUser: UserModel?
    let otherUsers: [UserModel]
}

final class AuthRepository: AuthRepositoryProtocol {

    private let authService: FirebaseAuthServiceProtocol

    //---------------------------
    // INITIALIZATION
    //---------------------------

    init(authService: FirebaseAuthServiceProtocol) {
        self.authService = authService
    }

    //---------------------------
    // Functions
    //---------------------------

    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        authService.login(email: email, password: password, completion: completion)
    }

    func fetchUsers(uid: String, completion: @escaping (Result<UsersResult, Error>) -> Void) {

        authService.fetchUsers { result in

            switch result {

            case .success(let users):

                let currentUser = users.first { $0.id == uid }

                let otherUsers = users.filter { $0.id != uid}

                let usersResult = UsersResult(currentUser: currentUser, otherUsers: otherUsers)

                completion(.success(usersResult))

            case .failure(let error):

                completion(.failure(error))
            }
        }
    }
    func logout() throws {
        try authService.logout()
    }
}
