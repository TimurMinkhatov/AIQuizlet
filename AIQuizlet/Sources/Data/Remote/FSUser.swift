//
//  FSUser.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 01/05/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation

struct FSUser: Codable {
    
    // MARK: - Properties
    
    let userId: String
    let email: String
    let totalQuizzes: Int
    let averageScore: Double
    let bestScore: Double
    let totalCompleted: Int
    
    // MARK: - Init
    
    var asDictionary: [String: Any] {
        return [
            "userId": userId,
            "email": email,
            "totalQuizzes": totalQuizzes,
            "averageScore": averageScore,
            "bestScore": bestScore,
            "totalCompleted": totalCompleted
        ]
    }
}
