import Foundation

struct UsersResult {
    let currentUser: UserModel?
    let otherUsers: [UserModel]
}

final class AuthRepository: AuthRepositoryProtocol {

    private let authService: FirebaseAuthServiceProtocol

    init(authService: FirebaseAuthServiceProtocol) {
        self.authService = authService
    }

    // MARK: - AUTHENTICATION
    
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        authService.login(email: email, password: password, completion: completion)
    }

    // MARK: - FETCH USER

    func fetchUsers(uid: String, completion: @escaping (UsersResult) -> Void) {
        authService.fetchUsers(uid: uid) { users in
            
            let currentUser = users.first { $0.id == uid }
            
            let otherUsers = users.filter {
                $0.id != uid
            }

            completion(UsersResult(currentUser: currentUser, otherUsers: otherUsers))
        }
    }
    
    // MARK: - LOGOUT
    
    func logout() throws {
        try authService.logout()
    }
}
