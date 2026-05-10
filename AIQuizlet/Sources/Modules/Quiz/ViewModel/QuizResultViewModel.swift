//
//  QuizResultViewModel.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 01.05.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation

final class QuizResultViewModel {
    
    // MARK: - Properties
    
    private let quizResult: QuizResult
    let isFromHistory: Bool
    private let sortedQuestions: [QuestionRecord]
    
    var onRetry: ((QuizRecord) -> Void)?
    var onHome: (() -> Void)?
    
    var expandedIndexSet = Set<Int>()
    
    // MARK: - ViewState
    
    var viewState: QuizResultView.ViewState {
        return QuizResultView.ViewState(
            scoreText: scoreText,
            statusText: statusText,
            descriptionText: resultDescription,
            percentage: percentageValue,
            questionsCount: numberOfQuestions
        )
    }
    
    // MARK: - Init
    
    init(
        quizResult: QuizResult,
        isFromHistory: Bool = false,
        onRetry: ((QuizRecord) -> Void)? = nil,
        onHome: (() -> Void)? = nil
    ) {
        self.quizResult = quizResult
        self.isFromHistory = isFromHistory
        self.sortedQuestions = quizResult.quiz.questions.sorted { $0.orderIndex < $1.orderIndex }
        self.onRetry = onRetry
        self.onHome = onHome
    }
    
    // MARK: - Private Computed Properties
    
    private var scoreText: String {
        "\(Int(quizResult.percentage))%"
    }
    
    private var statusText: String {
        let percent = quizResult.percentage
        if percent >= 100 { return L10n.Result.perfect }
        if percent >= 80 { return L10n.Result.great }
        if percent >= 50 { return L10n.Result.good }
        return L10n.Result.notBad
    }
    
    private var resultDescription: String {
        L10n.Result.correctCount(quizResult.score, quizResult.totalQuestions)

    }
    
    private var numberOfQuestions: Int {
        sortedQuestions.count
    }
    
    private var percentageValue: Double {
        quizResult.percentage
    }
    
    // MARK: - Public Methods
    
    func getQuestion(at index: Int) -> QuestionRecord {
        return sortedQuestions[index]
    }
    
    func getUserAnswer(at index: Int) -> Int {
        let targetQuestion = sortedQuestions[index]
        return quizResult.userAnswers.first(where: { $0.questionIndex == targetQuestion.orderIndex })?.selectedAnswer ?? -1
    }
    
    func retryQuiz() {
        onRetry?(quizResult.quiz)
    }
    
    func goHome() {
        onHome?()
    }
}
