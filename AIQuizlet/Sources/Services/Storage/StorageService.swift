//
//  StorageService.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 22/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import SwiftData
import Foundation

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
}

protocol StorageServiceProtocol {
    func saveQuizResult(_ quizResult: QuizResult) throws
    func fetchResults() throws -> [QuizResult]
    func fetchQuizzes() throws -> [QuizRecord]
    func deleteAll() throws
}
