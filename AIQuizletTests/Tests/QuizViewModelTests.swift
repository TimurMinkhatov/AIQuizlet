//
//  QuizViewModelTests.swift
//  AIQuizletTests
//

import XCTest
@testable import AIQuizlet

final class QuizViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    private var mockQuizService: MockQuizService!
    private var mockFirestoreService: MockFirestoreService!
    private var mockStorageService: MockStorageService!
    private var viewModel: QuizViewModel!
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        mockQuizService = MockQuizService()
        mockFirestoreService = MockFirestoreService()
        mockStorageService = MockStorageService()
        viewModel = QuizViewModel(
            quizService: mockQuizService,
            firestoreService: mockFirestoreService,
            storageService: mockStorageService
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockQuizService = nil
        mockFirestoreService = nil
        mockStorageService = nil
        super.tearDown()
    }
    
    // MARK: - Helpers
    
    private func makeQuiz(questionsCount: Int = 3) -> Quiz {
        let questions = (0..<questionsCount).map { index in
            Question(
                text: "Question \(index)",
                answers: ["A", "B", "C", "D"],
                correctAnswer: 0,
                explanation: nil
            )
        }
        return Quiz(title: "Test Quiz", questions: questions)
    }
    
    // MARK: - Tests
    
    func testInitialStateIsIdle() {
        // Then
        if case .idle = viewModel.state {
            XCTAssertTrue(true)
        } else {
            XCTFail("Initial state should be idle")
        }
    }
    
    func testSelectCorrectAnswerShowsCorrectResult() {
        // Given
        let quiz = makeQuiz()
        viewModel.setQuiz(quiz)
        
        // When
        viewModel.selectAnswer(index: 0)
        
        // Then
        if case .showingResult(let data) = viewModel.state {
            XCTAssertTrue(data.isCorrect)
        } else {
            XCTFail("State should be showingResult")
        }
    }
    
    func testSelectWrongAnswerShowsWrongResult() {
        // Given
        let quiz = makeQuiz()
        viewModel.setQuiz(quiz)
        
        // When
        viewModel.selectAnswer(index: 1) 
        
        // Then
        if case .showingResult(let data) = viewModel.state {
            XCTAssertFalse(data.isCorrect)
        } else {
            XCTFail("State should be showingResult")
        }
    }
    
    func testSelectAnswerSetsCorrectIndex() {
        // Given
        let quiz = makeQuiz()
        viewModel.setQuiz(quiz)
        
        // When
        viewModel.selectAnswer(index: 2)
        
        // Then
        if case .showingResult(let data) = viewModel.state {
            XCTAssertEqual(data.selectedIndex, 2)
            XCTAssertEqual(data.correctIndex, 0)
        } else {
            XCTFail("State should be showingResult")
        }
    }
    
    func testNextQuestionAdvancesToNextQuestion() {
        // Given
        let quiz = makeQuiz(questionsCount: 3)
        viewModel.setQuiz(quiz)
        viewModel.selectAnswer(index: 0)
        
        // When
        viewModel.nextQuestion()
        
        // Then
        if case .showingQuestion(_, let currentNumber, _) = viewModel.state {
            XCTAssertEqual(currentNumber, 2)
        } else {
            XCTFail("State should be showingQuestion")
        }
    }
    
    func testLastQuestionIsMarkedAsLast() {
        // Given
        let quiz = makeQuiz(questionsCount: 1)
        viewModel.setQuiz(quiz)
        
        // When
        viewModel.selectAnswer(index: 0)
        
        // Then
        if case .showingResult(let data) = viewModel.state {
            XCTAssertTrue(data.isLastQuestion)
        } else {
            XCTFail("State should be showingResult")
        }
    }
    
    func testCurrentNumberStartsAtOne() {
        // Given
        let quiz = makeQuiz()
        
        // When
        viewModel.setQuiz(quiz)
        
        // Then
        if case .showingQuestion(_, let currentNumber, let total) = viewModel.state {
            XCTAssertEqual(currentNumber, 1)
            XCTAssertEqual(total, 3)
        } else {
            XCTFail("State should be showingQuestion")
        }
    }
}
