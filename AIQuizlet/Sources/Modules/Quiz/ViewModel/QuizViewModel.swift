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
        case showingResult(isCorrect: Bool, correctIndex: Int, selectedIndex: Int, question: Question, isLastQuestion: Bool, currentNumber: Int, total: Int)
        case finished(score: Int, total: Int)
    }

    // MARK: - Properties
    
    weak var coordinator: QuizCoordinator?
    private var currentQuizRecord: QuizRecord?
    
    private var userAnswers: [Int: Int] = [:]

    private var quiz: Quiz?
    private var currentQuestionIndex = 0
    private let servicesAssembly: ServicesAssembly
    
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

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    // MARK: - Public Methods

    func setQuiz(_ quiz: Quiz, record: QuizRecord? = nil) {
        self.quiz = quiz
        self.currentQuizRecord = record
        self.currentQuestionIndex = 0
        self.userAnswers.removeAll()
        restoreCurrentQuestionState()
        
        Task {
            try? await saveQuiz(quiz)
        }
    }

    func selectAnswer(index: Int) {
        guard let quiz = quiz, currentQuestionIndex < quiz.questions.count else { return }
        let question = quiz.questions[currentQuestionIndex]
        
        userAnswers[currentQuestionIndex] = index
        
        let isCorrect = (index == question.correctAnswer)
        let isLastQuestion = (currentQuestionIndex == quiz.questions.count - 1)
        
        state = .showingResult(
            isCorrect: isCorrect,
            correctIndex: question.correctAnswer,
            selectedIndex: index,
            question: question,
            isLastQuestion: isLastQuestion,
            currentNumber: currentQuestionIndex + 1,
            total: quiz.questions.count
        )
    }

    func nextQuestion() {
        currentQuestionIndex += 1
        guard let total = quiz?.questions.count else {
            return
        }
        if currentQuestionIndex < total {
            showCurrentQuestion()
        } else {
            finishQuiz()
        }
    }
    
    func goBack() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
            restoreCurrentQuestionState()
        } else {
            coordinator?.didRequestRetake()
        }
    }
    
    func restart() {
        guard let quiz = quiz else { return }
            
        let questionRecords = quiz.questions.map {
            QuestionRecord(
                text: $0.text,
                answers: $0.answers,
                correctAnswer: $0.correctAnswer,
                explanation: $0.explanation
            )
        }
            
        let newRecord = QuizRecord(
            title: quiz.title,
            questions: questionRecords
        )
            
        self.currentQuizRecord = newRecord
        self.currentQuestionIndex = 0
        self.userAnswers.removeAll()
            
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
            finishQuiz()
        }
    }
    
    func finishQuiz() {
        guard let quiz = quiz, let record = currentQuizRecord else { return }
        
        var finalScore = 0
        var localAnswerRecords: [AnswerRecord] = []
        var remoteAnswers: [FSAnswer] = []
        
        for (index, question) in quiz.questions.enumerated() {
            if let selectedIndex = userAnswers[index] {
                let isCorrect = (selectedIndex == question.correctAnswer)
                if isCorrect {
                    finalScore += 1
                }
                
                localAnswerRecords.append(AnswerRecord(
                    questionIndex: index,
                    selectedAnswer: selectedIndex,
                    isCorrect: isCorrect
                ))
                
                remoteAnswers.append(FSAnswer(
                    questionIndex: index,
                    selectedAnswer: selectedIndex,
                    isCorrect: isCorrect
                ))
            }
        }
        
        let result = QuizResult(
            score: finalScore,
            totalQuestions: quiz.questions.count,
            quiz: record,
            userAnswers: localAnswerRecords
        )
        
        coordinator?.showResult(with: result)
        
        let scorePercentage = Double(finalScore) / Double(quiz.questions.count) * 100
        Task {
            try? await saveQuizResult(
                score: scorePercentage,
                total: quiz.questions.count,
                correctCount: finalScore,
                answers: remoteAnswers
            )
        }
    }
    
    func restoreCurrentQuestionState() {
        guard let quiz = quiz else { return }
        let question = quiz.questions[currentQuestionIndex]
        
        if let userAnswer = userAnswers[currentQuestionIndex] {
            let isCorrect = (userAnswer == question.correctAnswer)
            let isLastQuestion = (currentQuestionIndex == quiz.questions.count - 1)
            state = .showingResult(
                isCorrect: isCorrect,
                correctIndex: question.correctAnswer,
                selectedIndex: userAnswer,
                question: question,
                isLastQuestion: isLastQuestion,
                currentNumber: currentQuestionIndex + 1,
                total: quiz.questions.count
            )
        } else {
            state = .showingQuestion(
                question: question,
                currentNumber: currentQuestionIndex + 1,
                total: quiz.questions.count
            )
        }
    }
    
    private func saveQuizResult(score: Double, total: Int, correctCount: Int, answers: [FSAnswer]) async throws {
        let result = FSQuizResult(
            id: UUID().uuidString,
            userId: Auth.auth().currentUser?.uid ?? "",
            score: score,
            correctCount: correctCount,
            totalQuestions: total,
            completedAt: Date(),
            answers: answers
        )
        try await servicesAssembly.firestoreService.saveQuizResult(quizResult: result)
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
        try await servicesAssembly.firestoreService.saveQuiz(quiz: fsQuiz)
    }
}
