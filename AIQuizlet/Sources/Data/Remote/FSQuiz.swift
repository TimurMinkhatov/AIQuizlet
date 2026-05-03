//
//  FSTopic.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 01/05/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation

struct FSQuiz: Codable {

    // MARK: - Properties

    let id: String
    let userId: String
    let title: String
    let createdAt: Date
    let questions: [FSQuestion]

    // MARK: - Dictionary

    var asDictionary: [String: Any] {
        return [
            "id": id,
            "userId": userId,
            "title": title,
            "createdAt": createdAt,
            "questions": questions.map { $0.asDictionary }
        ]
    }
}
