//
//  HistoryViewModelTests.swift
//  AIQuizletTests
//

import XCTest
import SwiftData
@testable import AIQuizlet

@MainActor
final class HistoryViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    private var mockAuthService: MockAuthService!
    private var mockStorageService: MockStorageService!
    private var mockFirestoreService: MockFirestoreService!
    private var viewModel: HistoryViewModel!
    private var container: ModelContainer!
    
    // MARK: - Setup
    
    override func setUp() async throws {
        try await super.setUp()
        container = try TestModelContainer.make()
        mockAuthService = MockAuthService()
        mockStorageService = MockStorageService()
        mockFirestoreService = MockFirestoreService()
        viewModel = HistoryViewModel(
            authService: mockAuthService,
            storageService: mockStorageService,
            firestoreService: mockFirestoreService
        )
    }
    
    override func tearDown() async throws {
        viewModel = nil
        mockAuthService = nil
        mockStorageService = nil
        mockFirestoreService = nil
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
    
    func testSearchWithEmptyQueryReturnsAllResults() {
        // Given
        let result1 = makeQuizResult(title: "Math Quiz")
        let result2 = makeQuizResult(title: "History Quiz")
        viewModel.filteredResults = [result1, result2]
        
        // When
        viewModel.search(query: "")
        
        // Then
        XCTAssertEqual(viewModel.filteredResults.count, 0)
    }
    
    func testSearchWithNoMatchReturnsEmpty() {
        // Given
        let result = makeQuizResult(title: "Math Quiz")
        viewModel.filteredResults = [result]
        
        // When
        viewModel.search(query: "Physics")
        
        // Then
        XCTAssertEqual(viewModel.filteredResults.count, 0)
    }
    
    func testOnDataUpdatedCalledOnFilteredResultsChange() {
        // Given
        var callCount = 0
        viewModel.onDataUpdated = { callCount += 1 }
        
        // When
        viewModel.filteredResults = []
        
        // Then
        XCTAssertEqual(callCount, 1)
    }
}
