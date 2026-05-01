//
//  QuizViewModel.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 07.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation
import FirebaseAuth

final class QuizViewModel {

    // MARK: - State Enum

    enum State {
        case idle
        case showingQuestion(question: Question, currentNumber: Int, total: Int)
        case showingResult(isCorrect: Bool, correctIndex: Int, question: Question)
        case finished(score: Int, total: Int)
    }

    // MARK: - Properties

    private var quiz: Quiz?
    private var currentQuestionIndex = 0
    private var correctAnswersCount = 0
    private let assembly: ServicesAssembly
    
    private(set) var state: State = .idle {
        didSet {
            DispatchQueue.main.async {
                self.onStateChange?(self.state)
            }
        }
    }

    var onStateChange: ((State) -> Void)? {
        didSet {
            onStateChange?(state)
        }
    }

    // MARK: - Init

    init(assembly: ServicesAssembly) {
        self.assembly = assembly
    }

    // MARK: - Public Methods

    func setQuiz(_ quiz: Quiz) {
        self.quiz = quiz
        self.currentQuestionIndex = 0
        self.correctAnswersCount = 0
        showCurrentQuestion()
        Task {
            try? await saveQuiz(quiz)
        }
    }

    func selectAnswer(index: Int) {
        guard let quiz = quiz, currentQuestionIndex < quiz.questions.count else { return }
        let question = quiz.questions[currentQuestionIndex]
        
        let isCorrect = (index == question.correctAnswer)
        if isCorrect {
            correctAnswersCount += 1
        }
        state = .showingResult(isCorrect: isCorrect, correctIndex: question.correctAnswer, question: question)
    }

    func nextQuestion() {
        currentQuestionIndex += 1
        showCurrentQuestion()
    }
}

// MARK: - Private Methods

private extension QuizViewModel {

    func showCurrentQuestion() {
        guard let quiz = quiz else { return }
        
        if currentQuestionIndex < quiz.questions.count {
            let question = quiz.questions[currentQuestionIndex]
            state = .showingQuestion(
                question: question,
                currentNumber: currentQuestionIndex + 1,
                total: quiz.questions.count
            )
        } else {
            let score = Double(correctAnswersCount) / Double(quiz.questions.count) * 100
            state = .finished(score: correctAnswersCount, total: quiz.questions.count)
            Task {
                try? await saveQuizResult(score: score, total: quiz.questions.count)
            }
        }
    }
    
    private func saveQuizResult(score: Double, total: Int) async throws {
        let result = FSQuizResult(
            id: UUID().uuidString,
            userId: Auth.auth().currentUser?.uid ?? "",
            score: score,
            correctCount: correctAnswersCount,
            totalQuestions: total,
            completedAt: Date()
        )
        try await assembly.firestoreService.saveQuizResult(quizResult: result)
    }
    
    private func saveQuiz(_ quiz: Quiz) async throws {
        let fsQuiz = FSQuiz(
            id: UUID().uuidString,
            userId: Auth.auth().currentUser?.uid ?? "",
            title: quiz.title,
            createdAt: Date(),
            questions: quiz.questions.map {
                FSQuestion(
                    text: $0.text,
                    answers: $0.answers,
                    correctAnswer: $0.correctAnswer,
                    explanation: $0.explanation
                )
            }
        )
        try await assembly.firestoreService.saveQuiz(quiz: fsQuiz)
    }
}
