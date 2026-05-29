import XCTest
@testable import Ping
final class MockUserService: UserServiceProtocol {

    var mockUsers: [UserModel] = [
        UserModel(id: "1", firstName: "Harry", lastName: "Harry"),
        UserModel(id: "2", firstName: "Oliia", lastName: "Oliia"),
        UserModel(id: "3", firstName: "Nick", lastName: "Nick")
    ]

    func fetchUsers(completion: @escaping ([UserModel]) -> Void) {
        completion(mockUsers)
    }
}
