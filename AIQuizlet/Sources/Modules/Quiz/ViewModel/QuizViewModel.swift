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
    
    // MARK: - Models
    
    struct QuestionDisplayData {
        let question: Question
        let currentNumber: Int
        let total: Int
    }
    
    struct ResultDisplayData {
        let isCorrect: Bool
        let correctIndex: Int
        let selectedIndex: Int
        let question: Question
        let isLastQuestion: Bool
        let currentNumber: Int
        let total: Int
    }
    
    struct FinishDisplayData {
        let score: Int
        let total: Int
    }
    
    // MARK: - State Enum
    
    enum State {
        case idle
        case showingQuestion(question: Question, currentNumber: Int, total: Int)
        case showingResult(data: ResultDisplayData)
        case finished(score: Int, total: Int)
    }
    
    // MARK: - Properties
    
    weak var coordinator: QuizCoordinator?
    private let quizService: QuizServiceProtocol
    private let firestoreService: FirestoreService
    private let storageService: StorageServiceProtocol?
    
    private var quiz: Quiz?
    private var currentQuizRecord: QuizRecord?
    private var currentQuestionIndex = 0
    private var userAnswers: [Int: Int] = [:]
    
    private(set) var state: State = .idle {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let state = self?.state else { return }
                self?.onStateChange?(state)
            }
        }
    }
    
    var onStateChange: ((State) -> Void)? {
        didSet {
            onStateChange?(state)
        }
    }
    
    // MARK: - Init
    
    init(
        quizService: QuizServiceProtocol,
        firestoreService: FirestoreService,
        storageService: StorageServiceProtocol? = nil
    ) {
        self.quizService = quizService
        self.firestoreService = firestoreService
        self.storageService = storageService
    }
    
    // MARK: - Public Methods
    
    func setQuiz(_ quiz: Quiz, record: QuizRecord? = nil) {
        self.quiz = quiz
        self.currentQuizRecord = record
        self.currentQuestionIndex = 0
        self.userAnswers.removeAll()
        restoreCurrentQuestionState()
        
        Task {
            try? await saveQuizToFirestore(quiz)
        }
    }
    
    func selectAnswer(index: Int) {
        guard let quiz = quiz, currentQuestionIndex < quiz.questions.count else { return }
        let question = quiz.questions[currentQuestionIndex]
        
        userAnswers[currentQuestionIndex] = index
        
        let isCorrect = (index == question.correctAnswer)
        let isLastQuestion = (currentQuestionIndex == quiz.questions.count - 1)
        
        let data = ResultDisplayData(
            isCorrect: isCorrect,
            correctIndex: question.correctAnswer,
            selectedIndex: index,
            question: question,
            isLastQuestion: isLastQuestion,
            currentNumber: currentQuestionIndex + 1,
            total: quiz.questions.count
        )
        
        state = .showingResult(data: data)
    }
    
    func nextQuestion() {
        currentQuestionIndex += 1
        guard let total = quiz?.questions.count else { return }
        
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
        
        let questionRecords = quiz.questions.toQuestionRecords()
        let newRecord = QuizRecord(
            title: quiz.title,
            questions: questionRecords
        )
        
        currentQuizRecord = newRecord
        currentQuestionIndex = 0
        userAnswers.removeAll()
        showCurrentQuestion()
    }
    
    func loadFromRecord(_ record: QuizRecord) {
        let questions = record.questions.map { questionRecord in
            Question(
                text: questionRecord.text,
                answers: questionRecord.answers,
                correctAnswer: questionRecord.correctAnswer,
                explanation: questionRecord.explanation
            )
        }
        
        let quiz = Quiz(title: record.title, questions: questions)
        setQuiz(quiz, record: record)
    }
    
    // MARK: - Private Methods
    
    private func showCurrentQuestion() {
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
    
    private func finishQuiz() {
        guard let quiz = quiz, let record = currentQuizRecord else { return }
        
        let finalScore = calculateFinalScore(for: quiz)
        let answerRecords = createAnswerRecords(for: quiz)
        let firestoreAnswers = createFirestoreAnswers(for: quiz)
        
        let quizResult = QuizResult(
            score: finalScore,
            totalQuestions: quiz.questions.count,
            quiz: record,
            userAnswers: answerRecords
        )
        
        // Сохраняем результат локально через StorageService (если доступен)
        if let storageService = storageService {
            do {
                try storageService.saveQuizResult(quizResult)
            } catch {
                print("Failed to save quiz result locally: \(error.localizedDescription)")
            }
        }
        
        coordinator?.showResult(with: quizResult)
        
        // Сохраняем в Firestore асинхронно
        let scorePercentage = Double(finalScore) / Double(quiz.questions.count) * 100
        Task {
            try? await saveQuizResultToFirestore(
                score: scorePercentage,
                total: quiz.questions.count,
                correctCount: finalScore,
                answers: firestoreAnswers
            )
        }
    }
    
    private func restoreCurrentQuestionState() {
        guard let quiz = quiz else { return }
        let question = quiz.questions[currentQuestionIndex]
        
        if let userAnswer = userAnswers[currentQuestionIndex] {
            let isCorrect = (userAnswer == question.correctAnswer)
            let isLastQuestion = (currentQuestionIndex == quiz.questions.count - 1)
            let data = ResultDisplayData(
                isCorrect: isCorrect,
                correctIndex: question.correctAnswer,
                selectedIndex: userAnswer,
                question: question,
                isLastQuestion: isLastQuestion,
                currentNumber: currentQuestionIndex + 1,
                total: quiz.questions.count
            )
            
            state = .showingResult(data: data)
        } else {
            state = .showingQuestion(
                question: question,
                currentNumber: currentQuestionIndex + 1,
                total: quiz.questions.count
            )
        }
    }
    
    private func calculateFinalScore(for quiz: Quiz) -> Int {
        var score = 0
        for (index, question) in quiz.questions.enumerated() {
            if let selectedIndex = userAnswers[index], selectedIndex == question.correctAnswer {
                score += 1
            }
        }
        return score
    }
    
    private func createAnswerRecords(for quiz: Quiz) -> [AnswerRecord] {
        var records: [AnswerRecord] = []
        for (index, question) in quiz.questions.enumerated() {
            if let selectedIndex = userAnswers[index] {
                let isCorrect = (selectedIndex == question.correctAnswer)
                records.append(AnswerRecord(
                    questionIndex: index,
                    selectedAnswer: selectedIndex,
                    isCorrect: isCorrect
                ))
            }
        }
        return records
    }
    
    private func createFirestoreAnswers(for quiz: Quiz) -> [FSAnswer] {
        var answers: [FSAnswer] = []
        for (index, question) in quiz.questions.enumerated() {
            if let selectedIndex = userAnswers[index] {
                let isCorrect = (selectedIndex == question.correctAnswer)
                answers.append(FSAnswer(
                    questionIndex: index,
                    selectedAnswer: selectedIndex,
                    isCorrect: isCorrect
                ))
            }
        }
        return answers
    }
}

// MARK: - Firestore Operations

private extension QuizViewModel {
    
    func saveQuizResultToFirestore(score: Double, total: Int, correctCount: Int, answers: [FSAnswer]) async throws {
        let result = FSQuizResult(
            id: UUID().uuidString,
            userId: Auth.auth().currentUser?.uid ?? "",
            score: score,
            correctCount: correctCount,
            totalQuestions: total,
            completedAt: Date(),
            answers: answers
        )
        try await firestoreService.saveQuizResult(quizResult: result)
    }
    
    func saveQuizToFirestore(_ quiz: Quiz) async throws {
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
        try await firestoreService.saveQuiz(quiz: fsQuiz)
    }
}
