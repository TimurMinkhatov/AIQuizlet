//
//  QuizResponse.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 07.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation

// MARK: - API Response Models

struct QuizResponse: Decodable {
    let choices: [QuizChoice]
}

struct QuizChoice: Decodable {
    let message: Message
}

struct Message: Decodable {
    let content: String
}

// MARK: - Quiz Domain Models

struct Quiz: Decodable {
    let title: String
    let questions: [Question]
}

struct Question: Decodable {
    let text: String
    let answers: [String]
    let correctAnswer: Int
    let explanation: String?
}

// MARK: - Decoding Logic

extension Question {
    enum CodingKeys: String, CodingKey {
        case text, answers, correctAnswer, explanation
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.answers = try container.decode([String].self, forKey: .answers)
        self.correctAnswer = try container.decode(Int.self, forKey: .correctAnswer)
        self.explanation = try container.decodeIfPresent(String.self, forKey: .explanation)
    }
}
