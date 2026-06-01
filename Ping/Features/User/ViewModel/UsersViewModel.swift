import Foundation
import Combine

final class UsersViewModel: ObservableObject {

    @Published var users: [UserModel] = []
    @Published var searchText: String = ""

    private let repository: UserRepositoryProtocol

    //---------------------------
    // INITIALIZATION
    //---------------------------

    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    //---------------------------
    // Computed Property
    //---------------------------

    var filteredUsers: [UserModel] {

        if searchText.isEmpty {
            return users
        }

        return users.filter {
            let username = "\($0.firstName) \($0.lastName)"
            return username.localizedCaseInsensitiveContains(searchText)
        }
    }

    //---------------------------
    // LOAD USERS
    //---------------------------

    func loadUsers(currentUserId: String) {

        repository.getUsers(uid: currentUserId) { [weak self] users in

            DispatchQueue.main.async {
                self?.users = users
            }
        }
    }
}
