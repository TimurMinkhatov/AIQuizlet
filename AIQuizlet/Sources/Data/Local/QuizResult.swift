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
    
    var id: UUID
    var date: Date
    var score: Int
    var totalQuestions: Int
    var quiz: QuizRecord
    
    init(id: UUID = UUID(), date: Date = Date(), score: Int, totalQuestions: Int, quiz: QuizRecord) {
        self.id = id
        self.date = date
        self.score = score
        self.totalQuestions = totalQuestions
        self.quiz = quiz
    }
    
    var percentage: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(score) / Double(totalQuestions) * 100
    }
}
