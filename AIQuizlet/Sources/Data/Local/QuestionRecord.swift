//
//  QuestionRecord.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 21/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import SwiftData
import Foundation

@Model
class QuestionRecord {
    
    var id: UUID
    var orderIndex: Int
    var text: String
    var answers: [String]
    var correctAnswer: Int
    var explanation: String?
    
    init(id: UUID = UUID(), orderIndex: Int , text: String, answers: [String], correctAnswer: Int, explanation: String? = nil) {
        self.id = id
        self.orderIndex = orderIndex
        self.text = text
        self.answers = answers
        self.correctAnswer = correctAnswer
        self.explanation = explanation
    }
}
