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
    
    init(appConfig: AppConfiguration, repository: AuthRepositoryProtocol) {
        self.appConfig = appConfig
        self.repository = repository
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
                
                self.repository.getCurrentUser(uid: uid) { result in
                    
                    switch result {
                        
                    case .success(let user):
                        self.appConfig.loginSuccess(uid: uid)
                        self.state = .authenticated
                        
                    case .failure(let error):
                        
                        self.state = .unauthenticated(error.localizedDescription)
                        
                    }
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
