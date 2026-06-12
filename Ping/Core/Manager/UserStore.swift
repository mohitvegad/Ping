import Foundation
import Combine

//---------------------------
// Protocol
//---------------------------

protocol UserStoreProtocol {
    func setUsers(_ users: [UserModel])
    func user(id: String) -> UserModel?
    func clear()
}

@MainActor
final class UserStore: UserStoreProtocol, ObservableObject {

    static let shared = UserStore()

    @Published private(set) var usersById: [String: UserModel] = [:]

    //---------------------------
    // INITIALIZATION
    //---------------------------

    private init() {}

    //---------------------------
    // Computed Property
    //---------------------------
    
    var allUsers: [UserModel] {
        Array(usersById.values)
    }

    //---------------------------
    // Functions
    //---------------------------
    
    func setUsers(_ users: [UserModel]) {
        var dict: [String: UserModel] = [:]
        users.forEach { user in
            if let id = user.id {
                dict[id] = user
            }
        }

        self.usersById = dict
    }

    func user(id: String) -> UserModel? {
        usersById[id]
    }

    func clear() {
        usersById.removeAll()
    }
}
