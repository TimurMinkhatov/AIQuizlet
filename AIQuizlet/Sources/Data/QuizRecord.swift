//
//  QuizRecord.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 21/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import SwiftData
import Foundation

@Model
class QuizRecord {
    
    var id: UUID
    var title: String
    var date: Date
    @Relationship(deleteRule: .cascade) var questions: [QuestionRecord]
    
    init(id: UUID = UUID(), title: String, date: Date = Date(), questions: [QuestionRecord]) {
        self.id = id
        self.title = title
        self.date = date
        self.questions = questions
    }
}
