//
//  QuizPrompt.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 09.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation

// MARK: - QuizPrompt

enum QuizPrompt {
    static func generateQuiz(for text: String, count: Int) -> String {
        """
        Ты — профессиональный ИИ-репетитор. Твоя задача: создать тест на основе предоставленного текста.
        
        ИНСТРУКЦИЯ:
        1. Количество вопросов: СТРОГО \(count).
        2. Сложность: Вопросы должны проверять понимание ключевых фактов текста.
        3. Формат ответа: СТРОГО JSON. Не используй Markdown-блоки (типа ```json).
        4. Ответ должен содержать ТОЛЬКО объект JSON. Любой текст до или после будет считаться ошибкой.
        
        СТРУКТУРА JSON:
        {
          "title": "Краткое и емкое название темы",
          "questions": [
            {
              "text": "Текст вопроса?",
              "answers": ["Вариант A", "Вариант B", "Вариант C", "Вариант D"],
              "correctAnswer": 0, 
              "explanation": "Подробное объяснение, почему этот вариант верный."
            }
          ]
        }

        ТЕКСТ ДЛЯ АНАЛИЗА:
        \(text)
        """
    }
}
