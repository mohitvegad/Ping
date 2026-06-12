import Foundation

//---------------------------
// Protocol
//---------------------------

protocol AuthRepositoryProtocol {

    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)

    func fetchUsers(uid: String, completion: @escaping (UsersResult) -> Void)

    func logout() throws

}
