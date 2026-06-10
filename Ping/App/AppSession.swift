import Foundation
import Combine

enum AppSessionState {
    case idle
    case loggedIn(uId: String)
    case loggedOut
}

@MainActor
final class AppSession: ObservableObject {
    
    @Published var state: AppSessionState = .idle
    
    private let repository: AuthRepositoryProtocol
    private let keychain: KeychainServiceProtocol
    private let userSession: CurrentUserSessionProtocol
    private let userStore: UserStoreProtocol
    
    
    // MARK: - INIT
    init(repository: AuthRepositoryProtocol, keyChain: KeychainServiceProtocol, userSession: CurrentUserSessionProtocol, userStore: UserStoreProtocol) {
        self.repository = repository
        self.keychain = keyChain
        self.userSession = userSession
        self.userStore = userStore
    }
    
    func start() {
        guard let uid = keychain.get("userId") else { state = .loggedOut; return }
        
        repository.fetchUsers(uid: uid) { [weak self] result in
            guard let self = self else { return }
            self.state = .loggedIn(uId: uid)
            if let currentUser = result.currentUser {
                self.userSession.setUser(currentUser)
            }
            self.userStore.setUsers(result.otherUsers)
        }
    }
    
    func loginSuccess(uid: String) {
        keychain.save(uid, key: "userId")
        userSession.setUserId(uid)
        state = .loggedIn(uId: uid)
    }
    
    func logout() {
        keychain.delete("userId")
        userSession.clear()
        userStore.clear()
        state = .loggedOut
    }
}
