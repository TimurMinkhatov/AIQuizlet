//
//  StorageService.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 22/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import SwiftData
import Foundation

protocol StorageServiceProtocol {
    func saveQuizResult(_ quizResult: QuizResult) throws
    func fetchResults() throws -> [QuizResult]
    func fetchQuizzes() throws -> [QuizRecord]
    func deleteAll() throws
    func saveQuiz(_ quizRecord: QuizRecord) throws

    @MainActor
    func checkExists(id: String) throws -> Bool
    
    @MainActor
    func saveCloudQuiz(_ fsQuiz: FSQuiz, userId: String) throws
    
    @MainActor
    func checkResultExists(id: String) throws -> Bool
    
    @MainActor
    func saveCloudResult(_ fsResult: FSQuizResult, userId: String) throws
}

final class StorageService: StorageServiceProtocol {
    
    // MARK: - Properties
    
    private let modelContext: ModelContext
    
    // MARK: - Init
    
    init(modelContainer: ModelContainer) {
        self.modelContext = ModelContext(modelContainer)
    }
    
    // MARK: - Public Methods 
    
    func saveQuizResult(_ result: QuizResult) throws {
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
    
    func saveQuiz(_ quizRecord: QuizRecord) throws {
        modelContext.insert(quizRecord)
        try modelContext.save()
    }
    
    // MARK: - MainActor Methods
    
    @MainActor
    func checkExists(id: String) throws -> Bool {
        guard let uuid = UUID(uuidString: id) else { return false }
        
        let fetchDescriptor = FetchDescriptor<QuizRecord>(
            predicate: #Predicate<QuizRecord> { record in
                record.id == uuid
            }
        )
        
        let count = try modelContext.fetchCount(fetchDescriptor)
        return count > 0
    }
    
    @MainActor
    func saveCloudQuiz(_ fsQuiz: FSQuiz, userId: String) throws {
        guard let uuid = UUID(uuidString: fsQuiz.id) else { return }
        let questionRecords = fsQuiz.questions.enumerated().map { (index, fsQuestion) in
            QuestionRecord(
                orderIndex: index,
                text: fsQuestion.text,
                answers: fsQuestion.answers,
                correctAnswer: fsQuestion.correctAnswer,
                explanation: fsQuestion.explanation
            )
        }
        
        let quizRecord = QuizRecord(
            userId: userId,
            id: uuid,
            title: fsQuiz.title,
            date: fsQuiz.createdAt,
            questions: questionRecords
        )
        
        modelContext.insert(quizRecord)
        try modelContext.save()
    }
    
    @MainActor
    func checkResultExists(id: String) throws -> Bool {
        guard let uuid = UUID(uuidString: id) else { return false }
        let descriptor = FetchDescriptor<QuizResult>(
            predicate: #Predicate { $0.id == uuid }
        )
        let count = try modelContext.fetchCount(descriptor)
        return count > 0
    }

    @MainActor
    func saveCloudResult(_ fsResult: FSQuizResult, userId: String) throws {
        guard let resultUUID = UUID(uuidString: fsResult.id),
              let quizUUID = UUID(uuidString: fsResult.quizId) else { return }

        let targetQuizId = quizUUID
        let quizDescriptor = FetchDescriptor<QuizRecord>(
            predicate: #Predicate<QuizRecord> { $0.id == targetQuizId }
        )
        
        let quizRecord = try modelContext.fetch(quizDescriptor).first
        
        guard let quizRecord else {
            return
        }

        let answerRecords = fsResult.answers.map { fsAnswer in
            AnswerRecord(
                questionIndex: fsAnswer.questionIndex,
                selectedAnswer: fsAnswer.selectedAnswer,
                isCorrect: fsAnswer.isCorrect
            )
        }

        let quizResult = QuizResult(
            userId: userId,
            id: resultUUID,
            date: fsResult.completedAt,
            score: fsResult.correctCount,
            totalQuestions: fsResult.totalQuestions,
            quiz: quizRecord,
            userAnswers: answerRecords
        )

        modelContext.insert(quizResult)
        try modelContext.save()
    }
}
