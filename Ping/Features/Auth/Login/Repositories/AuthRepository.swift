import Foundation

final class AuthRepository: AuthRepositoryProtocol {

    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }

    // MARK: - LOGIN

    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {

        authService.login(email: email, password: password) { result in

            switch result {

            case .success(let uid):

                print("LOGIN SUCCESS:", uid)

                completion(.success(()))

            case .failure(let error):

                completion(.failure(error))
            }
        }
    }

    // MARK: - SIGN UP

    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {

        authService.signUp(email: email, password: password) { result in

            switch result {

            case .success(let uid):

                print("SIGNUP SUCCESS:", uid)

                completion(.success(()))

            case .failure(let error):

                completion(.failure(error))
            }
        }
    }

    // MARK: - LOGOUT

    func logout() throws {
        try authService.logout()
    }

    // MARK: - CURRENT USER

    func currentUserId() -> String? {
        authService.currentUserId()
    }
}
