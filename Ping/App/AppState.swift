import Foundation
import Combine

@MainActor
final class AppState: ObservableObject {
    
    enum State {
        case idle
        case loggedIn(String)
        case loggedOut
    }
    
    @Published var state: State = .idle
    
    private let keychain = KeychainManager.shared
    private let repository: AuthRepositoryProtocol
    
    
    // MARK: - INIT
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func start() {
        
        guard let uid = keychain.get("userId") else {
            state = .loggedOut
            return
        }
        
        repository.getCurrentUser(uid: uid) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    CurrentUserSession.shared.setUser(user)
                    self.state = .loggedIn(uid)
                case .failure:
                    self.logout()
                }
            }
        }
        
        repository.fetchUsers(uid: uid) { [weak self] users in
            guard let _ = self else { return }
            DispatchQueue.main.async {
                UserStore.shared.setUsers(users)
            }
        }
    }
    
    func loginSuccess(uid: String) {
        keychain.save(uid, key: "userId")
        CurrentUserSession.shared.setUserId(uid)
        state = .loggedIn(uid)
    }
    
    func logout() {
        keychain.delete("userId")
        CurrentUserSession.shared.clear()
        state = .loggedOut
    }
}
