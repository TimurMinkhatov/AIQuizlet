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

    @MainActor func checkExists(id: String) throws -> Bool
    @MainActor func saveCloudQuiz(_ fsQuiz: FSQuiz, userId: String) throws
    @MainActor func checkResultExists(id: String) throws -> Bool
    @MainActor func saveCloudResult(_ fsResult: FSQuizResult, userId: String) throws
}

final class StorageService: StorageServiceProtocol {
    
    private let modelContext: ModelContext
    
    init(modelContainer: ModelContainer) {
        self.modelContext = ModelContext(modelContainer)
    }
    
    func saveQuizResult(_ result: QuizResult) throws {
        modelContext.insert(result)
        try modelContext.save()
    }
    
    func fetchResults() throws -> [QuizResult] {
        let descriptor = FetchDescriptor<QuizResult>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return try modelContext.fetch(descriptor)
    }
    
    func fetchQuizzes() throws -> [QuizRecord] {
        let descriptor = FetchDescriptor<QuizRecord>(sortBy: [SortDescriptor(\.date, order: .reverse)])
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
        let all = try fetchQuizzes()
        return all.contains(where: { $0.id == id })
    }
    
    @MainActor
    func saveCloudQuiz(_ fsQuiz: FSQuiz, userId: String) throws {
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
            id: fsQuiz.id,
            title: fsQuiz.title,
            date: fsQuiz.createdAt,
            questions: questionRecords
        )
        
        modelContext.insert(quizRecord)
        try modelContext.save()
    }
    
    @MainActor
    func checkResultExists(id: String) throws -> Bool {
        let all = try fetchResults()
        return all.contains(where: { $0.id == id })
    }

    @MainActor
    func saveCloudResult(_ fsResult: FSQuizResult, userId: String) throws {
        let allQuizzes = try fetchQuizzes()
        guard let quizRecord = allQuizzes.first(where: { $0.id == fsResult.quizId }) else {
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
            id: fsResult.id,
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
