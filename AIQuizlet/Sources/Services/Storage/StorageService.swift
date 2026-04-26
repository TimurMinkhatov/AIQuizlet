//
//  StorageService.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 22/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import SwiftData
import Foundation

final class StorageService {
    
    // MARK: - Properties
    
    private let modelContext: ModelContext
    
    // MARK: - Init
    
    init(modelContainer: ModelContainer) {
        self.modelContext = ModelContext(modelContainer)
    }
    
    // MARK: - Public Methods
    
    func saveQuizResult(quiz: Quiz, score: Int) throws {
        let questions = quiz.questions.map {
            QuestionRecord(
                text: $0.text,
                answers: $0.answers,
                correctAnswer: $0.correctAnswer,
                explanation: $0.explanation
            )
        }
        let quizRecord = QuizRecord(title: quiz.title, questions: questions)
        let result = QuizResult(score: score, totalQuestions: quiz.questions.count, quiz: quizRecord)
        modelContext.insert(quizRecord)
        modelContext.insert(result)
        try modelContext.save()
    }
    
    func fetchResults() throws -> [QuizResult] {
        let descriptor = FetchDescriptor<QuizResult>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    func fetchQuizzes() throws -> [QuizRecord] {
        let descriptor = FetchDescriptor<QuizRecord>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    func deleteAll() throws {
        try modelContext.delete(model: QuizResult.self)
        try modelContext.delete(model: QuizRecord.self)
        try modelContext.delete(model: QuestionRecord.self)
        try modelContext.save()
    }
}
