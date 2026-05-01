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
    let isCorrect: Bool

    // MARK: - Dictionary

    var asDictionary: [String: Any] {
        return [
            "questionIndex": questionIndex,
            "selectedAnswer": selectedAnswer,
            "isCorrect": isCorrect
        ]
    }
}
