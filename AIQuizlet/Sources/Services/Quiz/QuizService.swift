//
//  QuizService.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 07.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//
import Foundation

final class QuizService {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchSavedQuizzes() async throws -> [Quiz] {
        return try await networkManager.request(target: .getQuizzes)
    }
    
    func generateQuiz(for text: String) async throws -> Quiz {
        let prompt = """
            На основе следующего текста создай тест. 
            Верни ответ СТРОГО в формате JSON без лишних слов, заголовков и Markdown-разметки.
            Структура JSON:
            {
              "title": "Название теста",
              "questions": [
                {
                  "text": "Вопрос",
                  "answers": ["Вариант 1", "Вариант 2", "Вариант 3", "Вариант 4"],
                  "correctAnswer": 0
                }
              ]
            }
            Текст: \(text)
            """
        let response: QuizResponse = try await networkManager.request(target: .generateQuiz(prompt: prompt))
        
        guard let jsonString = response.choices.first?.message.content,
              let jsonData = jsonString.data(using: .utf8) else {
            throw NSError(domain: "QuizService",code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse AI response"])
            
        }
        return try JSONDecoder().decode(Quiz.self, from: jsonData)
    }
}
