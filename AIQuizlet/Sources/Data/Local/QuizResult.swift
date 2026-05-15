//
//  QuizResult.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 21/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import SwiftData
import Foundation

@Model
final class QuizResult {
    
    var userId: String
    var id: String
    var date: Date
    var score: Int
    var totalQuestions: Int
    var quiz: QuizRecord
    @Relationship(deleteRule: .cascade) var userAnswers: [AnswerRecord]
    
    init(userId: String, id: String = UUID().uuidString, date: Date = Date(), score: Int, totalQuestions: Int, quiz: QuizRecord, userAnswers: [AnswerRecord]) {
        self.userId = userId
        self.id = id
        self.date = date
        self.score = score
        self.totalQuestions = totalQuestions
        self.quiz = quiz
        self.userAnswers = userAnswers
    }
    
    var percentage: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(score) / Double(totalQuestions) * 100
    }
}
