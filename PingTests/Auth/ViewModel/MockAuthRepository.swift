@testable import Ping

final class MockAuthRepository: AuthRepositoryProtocol {
    
    var loginResult: Result<String, Error>?
    var usersResult = UsersResult(
           currentUser: nil,
           otherUsers: []
       )
    
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        if let loginResult {
            completion(loginResult)
        }
    }
    
    func fetchUsers(uid: String, completion: @escaping (UsersResult) -> Void) {
        completion(usersResult)
    }
    
    func logout() throws {
        
    }
    
    
}
