//
//  FSQuestion.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 01/05/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation

struct FSQuestion: Codable {

    // MARK: - Properties

    let text: String
    let answers: [String]
    let correctAnswer: Int
    let explanation: String?

    // MARK: - Dictionary

    var asDictionary: [String: Any] {
        var dict: [String: Any] = [
            "text": text,
            "answers": answers,
            "correctAnswer": correctAnswer
        ]
        if let explanation {
            dict["explanation"] = explanation
        }
        return dict
    }
}
