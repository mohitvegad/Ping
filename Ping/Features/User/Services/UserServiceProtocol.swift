import Foundation

protocol UserServiceProtocol {
    func fetchCurrentUser(uid: String, completion: @escaping (UserModel?) -> Void)
    func fetchUsers(uid: String, completion: @escaping ([UserModel]) -> Void)
}
