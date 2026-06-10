@testable import Ping

final class MockAuthRepository: AuthRepositoryProtocol {
    
    var loginResult: Result<String, Error>?
    var currentUserResult: Result<UserModel, Error>?
    var usersResult: [UserModel] = []
    
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        if let loginResult {
            completion(loginResult)
        }
    }
    
    func getCurrentUser(uid: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        if let currentUserResult {
            completion(currentUserResult)
        }
    }
    
    func fetchUsers(uid: String, completion: @escaping ([UserModel]) -> Void) {
        completion(usersResult)
    }
    
    func logout() throws {
        
    }
    
    
}
