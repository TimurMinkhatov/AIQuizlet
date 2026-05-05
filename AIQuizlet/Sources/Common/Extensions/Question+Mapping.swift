//
//  Question+Mapping.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 05.05.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation

extension Question {
    
    func toQuestionRecord(orderIndex: Int) -> QuestionRecord {
        return QuestionRecord(
            orderIndex: orderIndex,
            text: self.text,
            answers: self.answers,
            correctAnswer: self.correctAnswer,
            explanation: self.explanation
        )
    }
}

extension Array where Element == Question {
    
    func toQuestionRecords(startingIndex: Int = 0) -> [QuestionRecord] {
        return enumerated().map { index, question in
            question.toQuestionRecord(orderIndex: startingIndex + index)
        }
    }
}
