//
//  FSQuizResult.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 01/05/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation

struct FSQuizResult: Codable {
    
    let quizId: String
    let id: String
    let userId: String
    var score: Double
    let correctCount: Int
    let totalQuestions: Int
    let completedAt: Date
    let answers: [FSAnswer]
    
    // MARK: - Enum
    
    enum CodingKeys: String, CodingKey {
        case quizId, id, userId, score, correctCount, totalQuestions, completedAt, answers
    }

    // MARK: - Init
    
    init(quizId: String, id: String, userId: String, score: Double, correctCount: Int, totalQuestions: Int, completedAt: Date, answers: [FSAnswer]) {
        self.quizId = quizId
        self.id = id
        self.userId = userId
        self.score = score
        self.correctCount = correctCount
        self.totalQuestions = totalQuestions
        self.completedAt = completedAt
        self.answers = answers
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.quizId = try container.decode(String.self, forKey: .quizId)
        self.id = try container.decode(String.self, forKey: .id)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.correctCount = try container.decode(Int.self, forKey: .correctCount)
        self.totalQuestions = try container.decode(Int.self, forKey: .totalQuestions)
        self.completedAt = try container.decode(Date.self, forKey: .completedAt)
        self.answers = try container.decode([FSAnswer].self, forKey: .answers)
        
        if let doubleScore = try? container.decode(Double.self, forKey: .score) {
            self.score = doubleScore
        } else if let intScore = try? container.decode(Int.self, forKey: .score) {
            self.score = Double(intScore)
        } else {
            self.score = 0.0
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(quizId, forKey: .quizId)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(score, forKey: .score)
        try container.encode(correctCount, forKey: .correctCount)
        try container.encode(totalQuestions, forKey: .totalQuestions)
        try container.encode(completedAt, forKey: .completedAt)
        try container.encode(answers, forKey: .answers)
    }

    // MARK: - Dictionary

    var asDictionary: [String: Any] {
        return [
            "quizId": quizId,
            "id": id,
            "userId": userId,
            "score": score,
            "correctCount": correctCount,
            "totalQuestions": totalQuestions,
            "completedAt": completedAt,
            "answers": answers.map { $0.asDictionary }
        ]
    }
}
