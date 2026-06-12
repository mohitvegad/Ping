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
    
    func makeCellModel(from user: UserModel) -> PingCellModel {

        PingCellModel(
            id: user.id ?? "",
            imageName: "person.fill",
            title: "\(user.firstName) \(user.lastName)",
            subtitle: user.pingStatus ?? "",
            unreadCount: 0,
            date: Date()
        )
    }
}
