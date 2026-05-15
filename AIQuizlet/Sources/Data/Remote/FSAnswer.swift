//
//  FSAnswer.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 01/05/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation

struct FSAnswer: Codable {

    // MARK: - Properties

    let questionIndex: Int
    let selectedAnswer: Int
    var isCorrect: Bool
    
    // MARK: - Enum
    
    enum CodingKeys: String, CodingKey {
        case questionIndex, selectedAnswer
        case isCorrect
        case correct = "correct"
    }
    
    // MARK: - Init
    
    init(questionIndex: Int, selectedAnswer: Int, isCorrect: Bool) {
        self.questionIndex = questionIndex
        self.selectedAnswer = selectedAnswer
        self.isCorrect = isCorrect
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.questionIndex = try container.decode(Int.self, forKey: .questionIndex)
        self.selectedAnswer = try container.decode(Int.self, forKey: .selectedAnswer)
        
        if let iosCorrect = try? container.decode(Bool.self, forKey: .isCorrect) {
            self.isCorrect = iosCorrect
        } else if let androidCorrect = try? container.decode(Bool.self, forKey: .correct) {
            self.isCorrect = androidCorrect
        } else {
            self.isCorrect = false
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(questionIndex, forKey: .questionIndex)
        try container.encode(selectedAnswer, forKey: .selectedAnswer)
        try container.encode(isCorrect, forKey: .isCorrect)
    }

    // MARK: - Dictionary

    var asDictionary: [String: Any] {
        return [
            "questionIndex": questionIndex,
            "selectedAnswer": selectedAnswer,
            "isCorrect": isCorrect
        ]
    }
}
