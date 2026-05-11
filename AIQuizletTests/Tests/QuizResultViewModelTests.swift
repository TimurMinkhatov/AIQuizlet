//
//  QuizResultViewModelTests.swift
//  AIQuizletTests
//

import XCTest
import SwiftData
@testable import AIQuizlet

final class QuizResultViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    private var container: ModelContainer!
    
    // MARK: - Setup
    
    override func setUp() async throws {
        try await super.setUp()
        container = try TestModelContainer.make()
    }
    
    override func tearDown() async throws {
        container = nil
        try await super.tearDown()
    }
    
    // MARK: - Helpers
    
    private func makeQuizResult(score: Int, total: Int) -> QuizResult {
        let context = ModelContext(container)
        let question = QuestionRecord(
            orderIndex: 0,
            text: "Test question",
            answers: ["A", "B", "C", "D"],
            correctAnswer: 0
        )
        let quiz = QuizRecord(
            userId: "test-user",
            title: "Test Quiz",
            questions: [question]
        )
        let result = QuizResult(
            userId: "test-user",
            score: score,
            totalQuestions: total,
            quiz: quiz,
            userAnswers: []
        )
        context.insert(result)
        return result
    }
    
    // MARK: - Tests
    
    func testPercentageCalculation() {
        // Given
        let result = makeQuizResult(score: 8, total: 10)
        let viewModel = QuizResultViewModel(quizResult: result)
        
        // When
        let percentage = viewModel.viewState.percentage
        
        // Then
        XCTAssertEqual(percentage, 80.0)
    }
    
    func testScoreText() {
        // Given
        let result = makeQuizResult(score: 8, total: 10)
        let viewModel = QuizResultViewModel(quizResult: result)
        
        // When
        let scoreText = viewModel.viewState.scoreText
        
        // Then
        XCTAssertEqual(scoreText, "80%")
    }
    
    func testQuestionsCount() {
        // Given
        let result = makeQuizResult(score: 5, total: 10)
        let viewModel = QuizResultViewModel(quizResult: result)
        
        // When
        let count = viewModel.viewState.questionsCount
        
        // Then
        XCTAssertEqual(count, 1)
    }
    
    func testGetUserAnswerReturnsMinusOneWhenNoAnswer() {
        // Given
        let result = makeQuizResult(score: 0, total: 10)
        let viewModel = QuizResultViewModel(quizResult: result)
        
        // When
        let answer = viewModel.getUserAnswer(at: 0)
        
        // Then
        XCTAssertEqual(answer, -1)
    }
    
    func testRetryQuiz() {
        // Given
        let result = makeQuizResult(score: 5, total: 10)
        var retryCalled = false
        let viewModel = QuizResultViewModel(
            quizResult: result,
            onRetry: { _ in retryCalled = true }
        )
        
        // When
        viewModel.retryQuiz()
        
        // Then
        XCTAssertTrue(retryCalled)
    }
    
    func testGoHome() {
        // Given
        let result = makeQuizResult(score: 5, total: 10)
        var homeCalled = false
        let viewModel = QuizResultViewModel(
            quizResult: result,
            onHome: { homeCalled = true }
        )
        
        // When
        viewModel.goHome()
        
        // Then
        XCTAssertTrue(homeCalled)
    }
    
    func testIsFromHistoryDefaultFalse() {
        // Given
        let result = makeQuizResult(score: 5, total: 10)
        
        // When
        let viewModel = QuizResultViewModel(quizResult: result)
        
        // Then
        XCTAssertFalse(viewModel.isFromHistory)
    }
    
    func testIsFromHistoryTrue() {
        // Given
        let result = makeQuizResult(score: 5, total: 10)
        
        // When
        let viewModel = QuizResultViewModel(quizResult: result, isFromHistory: true)
        
        // Then
        XCTAssertTrue(viewModel.isFromHistory)
    }
}
