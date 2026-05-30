import Foundation
import Combine

final class UsersViewModel: ObservableObject {

    @Published var users: [UserModel] = []
    @Published var searchText: String = ""

    private let userService: UserServiceProtocol

    //---------------------------
    // INITIALISATION
    //---------------------------

    init(service: UserServiceProtocol) {
        userService = service
    }
    
    //---------------------------
    // Computed Property
    //---------------------------

    var filteredUsers: [UserModel] {
        
        if searchText.isEmpty {
            return users
        }
        
        return users.filter {
            let username: String = $0.firstName + " " + $0.lastName
            return username.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func loadUsers() {
        userService.fetchUsers { [weak self] users in
            self?.users = users
        }
    }
}
