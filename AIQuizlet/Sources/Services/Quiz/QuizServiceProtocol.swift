//
//  QuizServiceProtocol.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 09.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation

// MARK: - QuizServiceProtocol

protocol QuizServiceProtocol {
    func generateQuiz(for text: String, count: Int) async throws -> Quiz
    func getQuizzes() async throws -> [Quiz]
}
