//
//  QuizService.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 07.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//
import Foundation

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
            return "Ошибка cети: \(error.localizedDescription)."
        }
    }
    
    
}

final class QuizService: QuizServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func getQuizzes() async throws -> [Quiz] {
        do {
            return try await networkManager.request(target: QuizAPI.getQuizzes)
        } catch {
            throw QuizServiceError.networkError(error)
        }
    }

    func generateQuiz(for text: String) async throws -> Quiz {
        let prompt = QuizPrompt.generateQuiz(for: text)
        let response: QuizResponse
        do {
            response = try await networkManager.request(target: QuizAPI.generateQuiz(prompt: prompt))
        } catch {
            throw QuizServiceError.networkError(error)
        }
        
        guard let jsonString = response.choices.first?.message.content,
              let jsonData = jsonString.data(using: .utf8) else {
            throw QuizServiceError.invalidAIResponse

        }
        
        do {
            return try JSONDecoder().decode(Quiz.self, from: jsonData)
        } catch {
            throw QuizServiceError.decodingFailed
        }
    }
}
