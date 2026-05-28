import Foundation
import Combine

final class UsersViewModel: ObservableObject {

    @Published var users: [UserModel] = []
    @Published var searchText: String = ""

    private let userService = UserService()

    //---------------------------
    // Computed Property
    //---------------------------

    var filteredUsers: [UserModel] {
        
        if searchText.isEmpty {
            return users
        }
        
        return users.filter {
            var username: String = $0.firstName + " " + $0.lastName
            return username.localizedCaseInsensitiveContains(searchText)
        }
    }

    //---------------------------
    // Computed Property
    //---------------------------
    
    func loadUsers() {
        userService.fetchUsers { [weak self] users in
            self?.users = users
        }
    }
}
