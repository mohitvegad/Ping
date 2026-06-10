import XCTest
@testable import Ping

@MainActor
final class LoginViewModelTests: XCTestCase {
    
    private func makeSUT() -> (sut: LoginViewModel, repo: MockAuthRepository) {

        let repository = MockAuthRepository()
        let keychain = MockKeychain()
        let session = MockUserSession()
        let store = MockUserStore()

        let appState = AppState(
            repository: repository,
            keyChain: keychain,
            userSession: session,
            userStore: store
        )

        let sut = LoginViewModel(
            appState: appState,
            repository: repository
        )

        return (sut, repository)
    }
    
    //MARK: -  Test Login EmptyFiels
    func testLoginWithEmptyFieldsShowsError() {
        
        // Arrange
        let (sut, _) = makeSUT()

        sut.email = ""
        sut.password = ""
        
        // Act
        sut.login()
        
        // Assert
        XCTAssertEqual(sut.state, .error("Please fill all fields"))
    }
    
    //MARK: - Test Login Success
    func testLoginSuccess() {

        // Arrange
        let (sut, repository) = makeSUT()

        repository.loginResult = .success("123")
        repository.currentUserResult = .success(
            UserModel(
                id: "123",
                firstName: "Test",
                lastName: "User",
                pingStatus: nil
            )
        )
        sut.email = "test@mail.com"
        sut.password = "123456"

        let expectation = XCTestExpectation(description: "login success")

        // Act
        sut.login()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(sut.state, .success("123"))
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
}
