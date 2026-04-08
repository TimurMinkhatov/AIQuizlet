//
//  QuizPrompt.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 09.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

enum QuizPrompt {
    static func generateQuiz(for text: String) -> String {
        return """
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
    }
}

