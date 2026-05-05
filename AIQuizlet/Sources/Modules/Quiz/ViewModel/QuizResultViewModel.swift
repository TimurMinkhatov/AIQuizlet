//
//  QuizResultViewModel.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 01.05.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

//
//  QuizResultViewModel.swift
//  AIQuizlet
//

import Foundation

final class QuizResultViewModel {
    
    // MARK: - Properties
    
    private let quizResult: QuizResult
    
    private let sortedQuestions: [QuestionRecord]
    
    var onDataLoaded: (() -> Void)?
    var onRetry: (() -> Void)?
    var onHome: (() -> Void)?
    
    init(quizResult: QuizResult) {
        self.quizResult = quizResult
        self.sortedQuestions = quizResult.quiz.questions.sorted { $0.orderIndex < $1.orderIndex }
    }
    
    // MARK: - Properties UI
    
    var scoreText: String {
        "\(Int(quizResult.percentage))%"
    }
    
    var statusText: String {
        let percent = quizResult.percentage
        if percent >= 100 { return "Идеально" }
        if percent >= 80  { return "Отлично" }
        if percent >= 50  { return "Хорошо" }
        return "Можно лучше"
    }
    
    var resultDescription: String {
        "\(quizResult.score) из \(quizResult.totalQuestions) правильных ответов"
    }
    
    var numberOfQuestions: Int {
        sortedQuestions.count
    }
    
    var percentageValue: Double {
        quizResult.percentage
    }
    
    var expandedIndexSet = Set<Int>()
    
    // MARK: - Methods
    
    func getQuestion(at index: Int) -> QuestionRecord {
        return sortedQuestions[index]
    }
    
    func getUserAnswer(at index: Int) -> Int {
        return quizResult.userAnswers.first(where: { $0.questionIndex == index })?.selectedAnswer ?? -1
    }
    
    func retryQuiz() {
        onRetry?()
    }
    
    func goHome() {
        onHome?()
    }
}
