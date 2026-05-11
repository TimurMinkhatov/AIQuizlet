//
//  AuthViewModelTests.swift
//  AIQuizletTests
//

import XCTest
@testable import AIQuizlet

final class AuthViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    private var mockAuthService: MockAuthService!
    private var mockFirestoreService: MockFirestoreService!
    private var viewModel: AuthViewModel!
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        mockAuthService = MockAuthService()
        mockFirestoreService = MockFirestoreService()
        viewModel = AuthViewModel(
            authService: mockAuthService,
            firestoreService: mockFirestoreService
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockAuthService = nil
        mockFirestoreService = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testSignInWithEmptyEmailShowsError() {
        // Given
        var errorMessage: String?
        viewModel.onError = { errorMessage = $0 }
        
        // When
        viewModel.signIn(email: "", password: "123456")
        
        // Then
        XCTAssertNotNil(errorMessage)
    }
    
    func testSignInWithInvalidEmailShowsError() {
        // Given
        var errorMessage: String?
        viewModel.onError = { errorMessage = $0 }
        
        // When
        viewModel.signIn(email: "invalidemail", password: "123456")
        
        // Then
        XCTAssertNotNil(errorMessage)
    }
    
    func testSignInWithEmptyPasswordShowsError() {
        // Given
        var errorMessage: String?
        viewModel.onError = { errorMessage = $0 }
        
        // When
        viewModel.signIn(email: "test@test.com", password: "")
        
        // Then
        XCTAssertNotNil(errorMessage)
    }
    
    func testRegisterWithShortPasswordShowsError() {
        // Given
        var errorMessage: String?
        viewModel.onError = { errorMessage = $0 }
        
        // When
        viewModel.register(email: "test@test.com", password: "123", confirmPassword: "123")
        
        // Then
        XCTAssertNotNil(errorMessage)
    }
    
    func testRegisterWithMismatchedPasswordsShowsError() {
        // Given
        var errorMessage: String?
        viewModel.onError = { errorMessage = $0 }
        
        // When
        viewModel.register(email: "test@test.com", password: "123456", confirmPassword: "654321")
        
        // Then
        XCTAssertNotNil(errorMessage)
    }
    
    func testSignInWithValidCredentialsCallsAuthService() {
        // Given — валидные данные
        
        // When
        viewModel.signIn(email: "test@test.com", password: "123456")
        
        // Then
        XCTAssertEqual(mockAuthService.signInCallCount, 1)
    }
    
    func testRegisterWithValidDataCallsAuthService() {
        // Given — валидные данные
        
        // When
        viewModel.register(email: "test@test.com", password: "123456", confirmPassword: "123456")
        
        // Then
        XCTAssertEqual(mockAuthService.registerCallCount, 1)
    }
}
