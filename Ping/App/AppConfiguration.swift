import Foundation
import Combine

enum AppConfigurationState {
    case idle
    case loggedIn(String)
    case loggedOut
}


@MainActor
final class AppConfiguration: ObservableObject {
    
    @Published var state: AppConfigurationState = .idle
    
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
        
        repository.getCurrentUser(uid: uid) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                userSession.setUser(user)
                self.state = .loggedIn(uid)
            case .failure:
                self.logout()
            }
        }
        
        repository.fetchUsers(uid: uid) { [weak self] users in
            guard let self = self else { return }
            userStore.setUsers(users)
        }
    }
    
    func loginSuccess(uid: String) {
        keychain.save(uid, key: "userId")
        userSession.setUserId(uid)
        state = .loggedIn(uid)
    }
    
    func logout() {
        keychain.delete("userId")
        userSession.clear()
        state = .loggedOut
    }
}
