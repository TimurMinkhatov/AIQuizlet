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
    let stats: UserStats
    
    // MARK: - Init
    
    init(userId: String, email: String, stats: UserStats = UserStats.initial()) {
        self.userId = userId
        self.email = email
        self.stats = stats
    }
    
    // MARK: - Codable
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decode(String.self, forKey: .userId)
        email = try container.decode(String.self, forKey: .email)
        
        let totalQuizzes = try container.decode(Int.self, forKey: .totalQuizzes)
        let totalCompleted = try container.decode(Int.self, forKey: .totalCompleted)
        let averageScore = try container.decode(Double.self, forKey: .averageScore)
        let bestScore = try container.decode(Double.self, forKey: .bestScore)
        
        stats = UserStats(
            totalQuizzes: totalQuizzes,
            totalCompleted: totalCompleted,
            averageScore: averageScore,
            bestScore: bestScore
        )
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(email, forKey: .email)
        try container.encode(stats.totalQuizzes, forKey: .totalQuizzes)
        try container.encode(stats.totalCompleted, forKey: .totalCompleted)
        try container.encode(stats.averageScore, forKey: .averageScore)
        try container.encode(stats.bestScore, forKey: .bestScore)
    }
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case userId, email
        case totalQuizzes, totalCompleted, averageScore, bestScore
    }
    
    // MARK: - Dictionary
    
    var asDictionary: [String: Any] {
        return [
            "userId": userId,
            "email": email,
            "totalQuizzes": stats.totalQuizzes,
            "totalCompleted": stats.totalCompleted,
            "averageScore": stats.averageScore,
            "bestScore": stats.bestScore
        ]
    }
}
