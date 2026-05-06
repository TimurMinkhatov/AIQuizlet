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
    let score: Double
    let correctCount: Int
    let totalQuestions: Int
    let completedAt: Date
    let answers: [FSAnswer]

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
