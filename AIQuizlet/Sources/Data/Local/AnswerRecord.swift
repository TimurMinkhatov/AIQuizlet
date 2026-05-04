//
//  AnswerRecord.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 04.05.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import SwiftData
import Foundation

@Model
class AnswerRecord {
    
    var questionIndex: Int
    var selectedAnswer: Int
    var isCorrect: Bool
    
    init(questionIndex: Int, selectedAnswer: Int, isCorrect: Bool) {
        self.questionIndex = questionIndex
        self.selectedAnswer = selectedAnswer
        self.isCorrect = isCorrect
    }
}
