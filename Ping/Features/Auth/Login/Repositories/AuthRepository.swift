import Foundation

final class AuthRepository: AuthRepositoryProtocol {

    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }

    // MARK: - AUTHENTICATION
    
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {

        authService.login(email: email, password: password) { result in

            switch result {

            case .success(let uid):
                print("LOGIN SUCCESS:", uid)
                completion(.success(uid))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - FETCH USER
    
    func getCurrentUser(uid: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        authService.getCurrentUser(uid: uid, completion: completion)
    }

    func fetchUsers(uid: String, completion: @escaping ([UserModel]) -> Void) {
        authService.fetchUsers(uid: uid) { users in
            // BUSINESS LOGIC LAYER
            let filteredUsers = users.filter { $0.id != uid }
            completion(filteredUsers)
        }
    }
    
    // MARK: - LOGOUT
    
    func logout() throws {
        try authService.logout()
    }
}
