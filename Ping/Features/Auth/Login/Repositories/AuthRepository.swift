import Foundation

//---------------------------
// Struct
//---------------------------

struct UsersResult {
    let currentUser: UserModel?
    let otherUsers: [UserModel]
}

final class AuthRepository: AuthRepositoryProtocol {

    private let authService: FirebaseAuthServiceProtocol

    //---------------------------
    // INITIALIZATION
    //---------------------------

    init(authService: FirebaseAuthServiceProtocol) {
        self.authService = authService
    }

    //---------------------------
    // Functions
    //---------------------------

    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        authService.login(email: email, password: password, completion: completion)
    }

    func fetchUsers(uid: String, completion: @escaping (UsersResult) -> Void) {
        authService.fetchUsers(uid: uid) { users in
            
            let currentUser = users.first { $0.id == uid }
            
            let otherUsers = users.filter {
                $0.id != uid
            }

            completion(UsersResult(currentUser: currentUser, otherUsers: otherUsers))
        }
    }
    
    func logout() throws {
        try authService.logout()
    }
}
