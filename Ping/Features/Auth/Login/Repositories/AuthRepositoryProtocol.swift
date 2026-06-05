import Foundation

protocol AuthRepositoryProtocol {

    func getCurrentUser(uid: String, completion: @escaping (Result<UserModel, Error>) -> Void)
    
    func fetchUsers(uid: String, completion: @escaping ([UserModel]) -> Void)

    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)

    func logout() throws

}
