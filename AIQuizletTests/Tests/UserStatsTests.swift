//
//  UserStatsTests.swift
//  AIQuizletTests
//

import XCTest
@testable import AIQuizlet

final class UserStatsTests: XCTestCase {

    // MARK: - Tests

    func testInitialStatsAreZero() {
        // When
        let stats = UserStats.initial()

        // Then
        XCTAssertEqual(stats.totalQuizzes, 0)
        XCTAssertEqual(stats.totalCompleted, 0)
        XCTAssertEqual(stats.averageScore, 0.0)
        XCTAssertEqual(stats.bestScore, 0.0)
    }

    func testUpdatedWithIncrementsTotalQuizzes() {
        // Given
        let stats = UserStats.initial()
        let result = FSQuizResult(
            quizId: "quiz-1",
            id: "result-1",
            userId: "user-1",
            score: 80.0,
            correctCount: 8,
            totalQuestions: 10,
            completedAt: Date(),
            answers: []
        )

        // When
        let updated = stats.updatedWith(newResult: result)

        // Then
        XCTAssertEqual(updated.totalQuizzes, 1)
    }

    func testUpdatedWithIncrementsTotalCompleted() {
        // Given
        let stats = UserStats.initial()
        let result = FSQuizResult(
            quizId: "quiz-1",
            id: "result-1",
            userId: "user-1",
            score: 80.0,
            correctCount: 8,
            totalQuestions: 10,
            completedAt: Date(),
            answers: []
        )

        // When
        let updated = stats.updatedWith(newResult: result)

        // Then
        XCTAssertEqual(updated.totalCompleted, 10)
    }

    func testUpdatedWithUpdatesBestScore() {
        // Given
        let stats = UserStats(totalQuizzes: 1, totalCompleted: 10, averageScore: 60.0, bestScore: 60.0)
        let result = FSQuizResult(
            quizId: "quiz-2",
            id: "result-2",
            userId: "user-1",
            score: 90.0,
            correctCount: 9,
            totalQuestions: 10,
            completedAt: Date(),
            answers: []
        )

        // When
        let updated = stats.updatedWith(newResult: result)

        // Then
        XCTAssertEqual(updated.bestScore, 90.0)
    }

    func testUpdatedWithKeepsBestScoreIfLower() {
        // Given
        let stats = UserStats(totalQuizzes: 1, totalCompleted: 10, averageScore: 90.0, bestScore: 90.0)
        let result = FSQuizResult(
            quizId: "quiz-2",
            id: "result-2",
            userId: "user-1",
            score: 50.0,
            correctCount: 5,
            totalQuestions: 10,
            completedAt: Date(),
            answers: []
        )

        // When
        let updated = stats.updatedWith(newResult: result)

        // Then
        XCTAssertEqual(updated.bestScore, 90.0)
    }

    func testUpdatedWithCalculatesAverageScore() {
        // Given
        let stats = UserStats(totalQuizzes: 1, totalCompleted: 10, averageScore: 60.0, bestScore: 60.0)
        let result = FSQuizResult(
            quizId: "quiz-2",
            id: "result-2",
            userId: "user-1",
            score: 80.0,
            correctCount: 8,
            totalQuestions: 10,
            completedAt: Date(),
            answers: []
        )

        // When
        let updated = stats.updatedWith(newResult: result)

        // Then
        XCTAssertEqual(updated.averageScore, 70.0)
    }
}
