//
//  QuizResultTests.swift
//  AIQuizletTests
//

import XCTest
import SwiftData
@testable import AIQuizlet

final class QuizResultTests: XCTestCase {

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
            text: "Test",
            answers: ["A", "B", "C", "D"],
            correctAnswer: 0
        )
        let quiz = QuizRecord(userId: "user", title: "Quiz", questions: [question])
        let result = QuizResult(userId: "user", score: score, totalQuestions: total, quiz: quiz, userAnswers: [])
        context.insert(result)
        return result
    }

    // MARK: - Tests

    func testPercentageCalculation() {
        // Given
        let result = makeQuizResult(score: 8, total: 10)

        // Then
        XCTAssertEqual(result.percentage, 80.0)
    }

    func testPerfectScore() {
        // Given
        let result = makeQuizResult(score: 10, total: 10)

        // Then
        XCTAssertEqual(result.percentage, 100.0)
    }

    func testZeroScore() {
        // Given
        let result = makeQuizResult(score: 0, total: 10)

        // Then
        XCTAssertEqual(result.percentage, 0.0)
    }

    func testZeroTotalQuestionsReturnsZero() {
        // Given
        let result = makeQuizResult(score: 0, total: 0)

        // Then
        XCTAssertEqual(result.percentage, 0.0)
    }
}
