import XCTest
@testable import Ping

@MainActor
final class LoginViewModelTests: XCTestCase {
    
    private func makeSUT() -> (sut: LoginViewModel, repo: MockAuthRepository) {

        let repository = MockAuthRepository()
        let keychain = MockKeychain()
        let session = MockUserSession()
        let store = MockUserStore()

        let appSession = AppSession(
            repository: repository,
            keyChain: keychain,
            userSession: session,
            userStore: store
        )

  
        let sut = LoginViewModel(appSession: appSession, repository: repository, userSession: session, userStore: store)

        return (sut, repository)
    }
    
    //MARK: -  Test Login EmptyFiels
    func testLoginWithEmptyFieldsShowsError() {
        
        // Arrange
        let (sut, _) = makeSUT()

        sut.email = kEmptyString
        sut.password = kEmptyString
        
        // Act
        sut.login()
        
        // Assert
        XCTAssertEqual(sut.state, .unauthenticated("Please fill all fields"))
    }
    
    //MARK: - Test Login Success
    func testLoginSuccess() {

        // Arrange
        let (sut, repository) = makeSUT()

        repository.loginResult = .success("123")
        repository.usersResult = UsersResult(currentUser: UserModel(
            id: "123",
            firstName: "Test",
            lastName: "User",
            pingStatus: nil
        ), otherUsers: [])
        
        sut.email = "test@mail.com"
        sut.password = "123456"

        let expectation = XCTestExpectation(description: "login success")

        // Act
        sut.login()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Assert
            XCTAssertEqual(sut.state, .authenticated)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
}
