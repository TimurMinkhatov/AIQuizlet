//
//  QuizService.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 07.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation

// MARK: - QuizServiceError

enum QuizServiceError: Error, LocalizedError {
    case invalidAIResponse
    case decodingFailed
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidAIResponse:
            return "Нейросеть прислала пустой или некорректный ответ."
        case .decodingFailed:
            return "Нейросеть не распознала текст, попробуйте еще раз."
        case .networkError(let error):
            return "Ошибка сети: \(error.localizedDescription)."
        }
    }
}

// MARK: - QuizService

final class QuizService: QuizServiceProtocol {
    
    // MARK: - Properties
    
    private let networkManager: NetworkManagerProtocol

    // MARK: - Init
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    // MARK: - Public Methods
    
    func getQuizzes() async throws -> [Quiz] {
        do {
            return try await networkManager.request(target: QuizAPI.getQuizzes)
        } catch {
            throw QuizServiceError.networkError(error)
        }
    }

    func generateQuiz(for text: String, count: Int) async throws -> Quiz {
        let prompt = QuizPrompt.generateQuiz(for: text, count: count)
        let response: QuizResponse
        
        do {
            response = try await networkManager.request(target: QuizAPI.generateQuiz(prompt: prompt))
        } catch {
            throw QuizServiceError.networkError(error)
        }
        
        guard let rawJsonString = response.choices.first?.message.content else {
            throw QuizServiceError.invalidAIResponse
        }
        
        print("Ответ нейронки")
        print(rawJsonString)
        
        let cleanedString = rawJsonString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .replacingOccurrences(of: "\n", with: "")
        
        guard let jsonData = cleanedString.data(using: .utf8) else {
            print("Не удалось преобразовать строку в Data")
            throw QuizServiceError.decodingFailed
        }
        
        do {
            let quiz = try JSONDecoder().decode(Quiz.self, from: jsonData)
            print(" Успешно распарсили квиз: \(quiz.title)")
            return quiz
        } catch {
            print(" Ошибка парсинга JSON: \(error)")
            throw QuizServiceError.decodingFailed
        }
    }
}
