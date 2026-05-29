import XCTest
@testable import Ping

final class UsersViewModelTests: XCTestCase {

    var viewModel: UsersViewModel!
    var mockService: MockUserService!

    override func setUp() {
        super.setUp()
        mockService = MockUserService()
        viewModel = UsersViewModel(service: mockService)
    }

    func test_loadUsers_shouldReturnUsers() {

        viewModel.loadUsers()

        XCTAssertEqual(viewModel.users.count, 3)
    }

    func test_searchFiltersUsers() {
        
        viewModel.loadUsers()

        viewModel.searchText = "har"

        XCTAssertEqual(viewModel.filteredUsers.count, 1)
        XCTAssertEqual(viewModel.filteredUsers.first?.firstName, "Harry")
    }
}
