import Foundation
import Combine

enum LoginViewState: Equatable {
    case idle
    case loading
    case success(String)
    case error(String)
}

import Foundation

@MainActor
final class LoginViewModel: ObservableObject {

    @Published var email = ""
    @Published var password = ""

    @Published var state: LoginViewState = .idle
    private let appState: AppState

    private let repository: AuthRepositoryProtocol

    init(appState: AppState, repository: AuthRepositoryProtocol) {
        self.appState = appState

        self.repository = repository
    }

    func login() {

        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !email.isEmpty, !password.isEmpty else {
            state = .error("Please fill all fields")
            return
        }

        state = .loading

        repository.login(email: email, password: password) { [weak self] result in

            DispatchQueue.main.async {

                guard let self else { return }

                switch result {

                case .success(let uid):
                    self.appState.loginSuccess(uid: uid)
                    self.state = .success(uid)

                case .failure(let error):
                    self.state = .error(error.localizedDescription)
                }
            }
        }
    }

    func reset() {
        state = .idle
    }
}
