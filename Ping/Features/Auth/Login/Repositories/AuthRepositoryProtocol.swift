import Foundation

protocol AuthRepositoryProtocol {

    func getCurrentUser(uid: String, completion: @escaping (Result<UserModel, Error>) -> Void)

    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)

    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)

    func logout() throws

    func currentUserId() -> String?
}
