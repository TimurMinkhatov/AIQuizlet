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
    
    var userId: String
    var id: String
    var title: String
    var date: Date
    @Relationship(deleteRule: .cascade) var questions: [QuestionRecord]
    
    init(userId: String, id: String = UUID().uuidString, title: String, date: Date = Date(), questions: [QuestionRecord]) {
        self.userId = userId
        self.id = id
        self.title = title
        self.date = date
        self.questions = questions
    }
}
