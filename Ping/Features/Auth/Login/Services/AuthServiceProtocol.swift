import Foundation

enum AuthError: LocalizedError {

    case userNotFound

    var errorDescription: String? {

        switch self {

        case .userNotFound:
            return "User not found"
        }
    }
}

protocol AuthServiceProtocol {

    func login(
        email: String,
        password: String,
        completion: @escaping (Result<String, Error>) -> Void
    )

    func signUp(
        email: String,
        password: String,
        completion: @escaping (Result<String, Error>) -> Void
    )

    func logout() throws

    func currentUserId() -> String?
}
