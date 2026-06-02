import Foundation

protocol UserRepositoryProtocol {
    func getUsers(uid: String, completion: @escaping ([UserModel]) -> Void)
}
