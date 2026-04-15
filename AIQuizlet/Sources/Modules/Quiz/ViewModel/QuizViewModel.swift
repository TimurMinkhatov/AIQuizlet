//
//  QuizViewModel.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 07.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation

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
    private let quizService: QuizService
    
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

    init(quizService: QuizService) {
        self.quizService = quizService
    }

    // MARK: - Public Methods

    func setQuiz(_ quiz: Quiz) {
        self.quiz = quiz
        self.currentQuestionIndex = 0
        self.correctAnswersCount = 0
        showCurrentQuestion()
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
            state = .finished(score: correctAnswersCount, total: quiz.questions.count)
        }
    }
}
