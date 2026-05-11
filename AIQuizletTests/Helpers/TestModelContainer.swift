// AIQuizletTests/Helpers/TestModelContainer.swift
import SwiftData
import Foundation
@testable import AIQuizlet

final class TestModelContainer {
    static func make() throws -> ModelContainer {
        let schema = Schema([
            QuizRecord.self,
            QuestionRecord.self,
            QuizResult.self,
            AnswerRecord.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: [config])
    }
}
