import Foundation
import Combine


@MainActor
final class AppState: ObservableObject {

    enum State {
        case loading
        case loggedIn(String)
        case loggedOut
    }

    @Published var state: State = .loading

    private let keychain = KeychainManager.shared

    func start() {

        if let uid = keychain.get("userId") {
            print("UID FOUND:", uid)
            CurrentUserSession.shared.userId = uid
            state = .loggedIn(uid)

        } else {
            state = .loggedOut
        }
    }

    func loginSuccess(uid: String) {
        keychain.save(uid, key: "userId")
        CurrentUserSession.shared.userId = uid
        state = .loggedIn(uid)
    }

    func logout() {
        keychain.delete("userId")
        CurrentUserSession.shared.userId = nil
        state = .loggedOut
    }
}
