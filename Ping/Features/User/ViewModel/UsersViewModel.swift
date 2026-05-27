import Foundation
import Combine

final class UsersViewModel: ObservableObject {

    @Published var users: [UserModel] = []

    private let userService = UserService()

//    var filteredUsers: [UserModel] {
//        
//        if searchText.isEmpty {
//            return users
//        }
//        
//        return users.filter {
//            $0.userName.localizedCaseInsensitiveContains(searchText)
//        }
//    }
    
    func loadUsers() {
        userService.fetchUsers { [weak self] users in
            self?.users = users
        }
    }
}
