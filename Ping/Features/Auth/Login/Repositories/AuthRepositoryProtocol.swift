import Foundation

//---------------------------
// Protocol
//---------------------------

protocol AuthRepositoryProtocol {

    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)

    func fetchUsers(uid: String, completion: @escaping (Result<UsersResult, Error>) -> Void)

    func logout() throws

}
