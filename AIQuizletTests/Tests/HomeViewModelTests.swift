//
//  HomeViewModelTests.swift
//  AIQuizletTests
//

import XCTest
import SwiftData
@testable import AIQuizlet

final class HomeViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    private var mockAuthService: MockAuthService!
    private var mockStorageService: MockStorageService!
    private var viewModel: HomeViewModel!
    private var container: ModelContainer!
    
    // MARK: - Setup
    
    override func setUp() async throws {
        try await super.setUp()
        container = try TestModelContainer.make()
        mockAuthService = MockAuthService()
        mockStorageService = MockStorageService()
        viewModel = HomeViewModel(
            authService: mockAuthService,
            storageService: mockStorageService
        )
    }
    
    override func tearDown() async throws {
        viewModel = nil
        mockAuthService = nil
        mockStorageService = nil
        container = nil
        try await super.tearDown()
    }
    
    // MARK: - Helpers
    
    private func makeQuizResult(title: String, userId: String = "test-user") -> QuizResult {
        let context = ModelContext(container)
        let question = QuestionRecord(
            orderIndex: 0,
            text: "Test question",
            answers: ["A", "B", "C", "D"],
            correctAnswer: 0
        )
        let quiz = QuizRecord(
            userId: userId,
            title: title,
            questions: [question]
        )
        let result = QuizResult(
            userId: userId,
            score: 5,
            totalQuestions: 10,
            quiz: quiz,
            userAnswers: []
        )
        context.insert(result)
        return result
    }
    
    // MARK: - Tests
    
    func testFetchRecentTestsWithNoUserReturnsEmpty() {
        // Given
        mockAuthService.currentUserId = nil
        var callCount = 0
        viewModel.onDataUpdated = { callCount += 1 }
        
        // When
        viewModel.fetchRecentTests()
        
        // Then
        XCTAssertTrue(viewModel.recentTests.isEmpty)
        XCTAssertEqual(callCount, 1)
    }
    
    func testFetchRecentTestsReturnsMaxThree() {
        // Given
        mockAuthService.currentUserId = "test-user"
        let results = (0..<5).map { makeQuizResult(title: "Quiz \($0)") }
        mockStorageService.fetchResultsReturnValue = results
        
        // When
        viewModel.fetchRecentTests()
        
        // Then
        XCTAssertEqual(viewModel.recentTests.count, 3)
    }
    
    func testFetchRecentTestsCallsOnDataUpdated() {
        // Given
        mockAuthService.currentUserId = "test-user"
        mockStorageService.fetchResultsReturnValue = []
        var callCount = 0
        viewModel.onDataUpdated = { callCount += 1 }
        
        // When
        viewModel.fetchRecentTests()
        
        // Then
        XCTAssertEqual(callCount, 1)
    }
    
    func testFetchRecentTestsFiltersOtherUsers() {
        // Given
        mockAuthService.currentUserId = "user-1"
        let myResult = makeQuizResult(title: "My Quiz", userId: "user-1")
        let otherResult = makeQuizResult(title: "Other Quiz", userId: "user-2")
        mockStorageService.fetchResultsReturnValue = [myResult, otherResult]
        
        // When
        viewModel.fetchRecentTests()
        
        // Then
        XCTAssertEqual(viewModel.recentTests.count, 1)
        XCTAssertEqual(viewModel.recentTests.first?.title, "My Quiz")
    }
    
    func testFetchRecentTestsOnErrorCallsOnDataUpdated() {
        // Given
        mockAuthService.currentUserId = "test-user"
        mockStorageService.fetchResultsThrowableError = NSError(domain: "test", code: 0)
        var callCount = 0
        viewModel.onDataUpdated = { callCount += 1 }
        
        // When
        viewModel.fetchRecentTests()
        
        // Then
        XCTAssertTrue(viewModel.recentTests.isEmpty)
        XCTAssertEqual(callCount, 1)
    }
}
