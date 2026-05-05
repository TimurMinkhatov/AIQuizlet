//
//  UserStats.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 05.05.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation

struct UserStats: Codable {
    let totalQuizzes: Int
    let totalCompleted: Int
    let averageScore: Double
    let bestScore: Double
    
    // MARK: - Init
    
    init(totalQuizzes: Int, totalCompleted: Int, averageScore: Double, bestScore: Double) {
        self.totalQuizzes = totalQuizzes
        self.totalCompleted = totalCompleted
        self.averageScore = averageScore
        self.bestScore = bestScore
    }
    
    init(from dictionary: [String: Any]) {
        self.totalQuizzes = dictionary["totalQuizzes"] as? Int ?? 0
        self.totalCompleted = dictionary["totalCompleted"] as? Int ?? 0
        self.averageScore = dictionary["averageScore"] as? Double ?? 0.0
        self.bestScore = dictionary["bestScore"] as? Double ?? 0.0
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "totalQuizzes": totalQuizzes,
            "totalCompleted": totalCompleted,
            "averageScore": averageScore,
            "bestScore": bestScore
        ]
    }
    
    // MARK: - Static Methods
    
    static func initial() -> UserStats {
        return UserStats(
            totalQuizzes: 0,
            totalCompleted: 0,
            averageScore: 0.0,
            bestScore: 0.0
        )
    }
    
    // MARK: - Methods
    
    func updatedWith(newResult: FSQuizResult) -> UserStats {
        let newTotalQuizzes = totalQuizzes + 1
        let newTotalCompleted = totalCompleted + newResult.totalQuestions
        let newAverageScore = (averageScore * Double(totalQuizzes) + newResult.score) / Double(newTotalQuizzes)
        let newBestScore = max(bestScore, newResult.score)
        
        return UserStats(
            totalQuizzes: newTotalQuizzes,
            totalCompleted: newTotalCompleted,
            averageScore: newAverageScore,
            bestScore: newBestScore
        )
    }
}
