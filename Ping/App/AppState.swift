import Foundation
import Combine
import FirebaseAuth

@MainActor
final class AppState: ObservableObject {

    @Published var isReady = false

    func start() {

        AuthManager.shared.loginAsGuest { [weak self] success in
            guard let self else { return }

            guard success else {
                print("Auth failed → stop app")
                return
            }

            self.seedUsersIfNeeded()
        }
    }
    private func seedUsersIfNeeded() {

        if !UserDefaults.standard.bool(forKey: "didSeedUsers") {
            UserSeeder().seedUsers()
            UserDefaults.standard.set(true, forKey: "didSeedUsers")
        }

        DispatchQueue.main.async {
            self.isReady = true
        }
    }
}
