import Foundation
import Combine

enum LoginViewState: Equatable {
    case idle
    case authenticating
    case authenticated
    case unauthenticated(String)
}

@MainActor
final class LoginViewModel: ObservableObject {
    
    @Published var email = kEmptyString
    @Published var password = kEmptyString
    @Published var state: LoginViewState = .idle
    
    private let appConfig: AppConfiguration
    private let repository: AuthRepositoryProtocol
    private let userSession: CurrentUserSessionProtocol
    private let userStore: UserStoreProtocol
    
    init(appConfig: AppConfiguration, repository: AuthRepositoryProtocol, userSession: CurrentUserSessionProtocol, userStore: UserStoreProtocol) {
        self.appConfig = appConfig
        self.repository = repository
        self.userSession = userSession
        self.userStore = userStore
    }
    
    func login() {
        
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !email.isEmpty, !password.isEmpty else {
            state = .unauthenticated("Please fill all fields")
            return
        }
        
        state = .authenticating
        
        repository.login(email: email, password: password) { [weak self] result in
            
            guard let self else { return }
            
            switch result {
                
            case .success(let uid):
                repository.fetchUsers(uid: uid) { [weak self] result in
                    guard let self = self else { return }
                    
                    self.state = .authenticated
                    self.appConfig.loginSuccess(uid: uid)
                    
                    if let currentUser = result.currentUser {
                        self.userSession.setUser(currentUser)
                    }
                    self.userStore.setUsers(result.otherUsers)
                }
            case .failure(let error):
                
                self.state = .unauthenticated(error.localizedDescription)
                
            }
        }
    }
    
    func reset() {
        state = .idle
    }
}
