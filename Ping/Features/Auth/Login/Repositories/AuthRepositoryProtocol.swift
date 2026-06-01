import Foundation

protocol AuthRepositoryProtocol {

    func login(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )

    func signUp(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )

    func logout() throws

    func currentUserId() -> String?
}
