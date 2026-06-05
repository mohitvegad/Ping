import Foundation
import Combine

@MainActor
final class UsersViewModel: ObservableObject {

    @Published var searchText: String = ""

    private let userStore = UserStore.shared

    // MARK: - FILTERED USERS
    var filteredUsers: [UserModel] {

        let users = userStore.allUsers

        if searchText.isEmpty {
            return users
        }

        return users.filter {

            let username = "\($0.firstName) \($0.lastName)"

            return username.localizedCaseInsensitiveContains(searchText)
        }
    }
}
