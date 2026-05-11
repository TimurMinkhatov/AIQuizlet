//
//  ProfileViewModelTests.swift
//  AIQuizletTests
//

import XCTest
import SwiftData
@testable import AIQuizlet

final class ProfileViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    private var mockAuthService: MockAuthService!
    private var mockStorageService: MockStorageService!
    private var mockFirestoreService: MockFirestoreService!
    private var viewModel: ProfileViewModel!
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        mockAuthService = MockAuthService()
        mockStorageService = MockStorageService()
        mockFirestoreService = MockFirestoreService()
        viewModel = ProfileViewModel(
            firestoreService: mockFirestoreService,
            storageService: mockStorageService,
            authService: mockAuthService
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockAuthService = nil
        mockStorageService = nil
        mockFirestoreService = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testFetchStatsReturnsZeroWhenNoUser() async throws {
        // Given
        mockFirestoreService.fetchUserReturnValue = nil
        mockAuthService.currentUser = nil
        mockStorageService.fetchResultsReturnValue = []
        
        // When
        let stats = try await viewModel.fetchStats()
        
        // Then
        XCTAssertEqual(stats.totalQuizzes, 0)
        XCTAssertEqual(stats.avgScore, 0)
        XCTAssertEqual(stats.bestScore, 0)
        XCTAssertEqual(stats.totalQuestions, 0)
    }
    
    func testFetchStatsFromFirestore() async throws {
        // Given
        let fsStats = UserStats(
            totalQuizzes: 5,
            totalCompleted: 50,
            averageScore: 80.0,
            bestScore: 95.0
        )
        let fsUser = FSUser(userId: "test-user", email: "test@test.com", stats: fsStats)
        mockFirestoreService.fetchUserReturnValue = fsUser
        
        // When
        let stats = try await viewModel.fetchStats()
        
        // Then
        XCTAssertEqual(stats.totalQuizzes, 5)
        XCTAssertEqual(stats.avgScore, 80.0)
        XCTAssertEqual(stats.bestScore, 95.0)
        XCTAssertEqual(stats.totalQuestions, 50)
    }
    
    func testEmailReturnsUnknownWhenNoUser() {
        // Given
        mockAuthService.currentUser = nil
        
        // When
        let email = viewModel.email
        
        // Then
        XCTAssertEqual(email, "Unknown")
    }
    
    func testLogoutCallsSignOut() {
        // When
        viewModel.logout()
        
        // Then
        XCTAssertEqual(mockAuthService.signOutCallCount, 1)
    }
    
    func testClearDataCallsDeleteAll() {
        // When
        viewModel.clearData()
        
        // Then
        XCTAssertEqual(mockStorageService.deleteAllCallCount, 1)
    }
}
