import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {

    // MARK: - INPUT
    @Published var email: String = ""
    @Published var password: String = ""

    // MARK: - OUTPUT STATE
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let repository: AuthRepositoryProtocol

    // MARK: - INIT
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - LOGIN ACTION
    func login() {

        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password required"
            return
        }

        isLoading = true
        errorMessage = nil

        repository.login(email: email, password: password) { [weak self] result in

            guard let self else { return }

            DispatchQueue.main.async {
                self.isLoading = false

                switch result {

                case .success:

                    print("LOGIN SUCCESS → Navigate to Home")


                case .failure(let error):

                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    // MARK: - OPTIONAL: CLEAR STATE
    func reset() {
        email = ""
        password = ""
        errorMessage = nil
        isLoading = false
    }
}
