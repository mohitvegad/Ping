import Foundation

protocol UserRepositoryProtocol {
    func getCurrentUser(uid: String, completion: @escaping (UserModel?) -> Void)
    func getUsers(uid: String, completion: @escaping ([UserModel]) -> Void)
}
