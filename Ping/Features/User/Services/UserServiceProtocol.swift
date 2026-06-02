import Foundation

protocol UserServiceProtocol {
    func fetchUsers(uid: String, completion: @escaping ([UserModel]) -> Void)
}
