//
//  ProfileViewModel.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 25/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation

final class ProfileViewModel {
    
    // MARK: - Properties
    
    weak var coordinator: ProfileCoordinator?
    private let storageService: StorageService
    var onError: ((String) -> Void)?
    var email: String = AuthService.shared.currentUser?.email ?? "Unknown"
    
    
    // MARK: - Init
    
    init(storageService: StorageService) {
        self.storageService = storageService
    }
    
    // MARK: - Public Methods
    
    func logout() {
        AuthService.shared.signOut()
        coordinator?.didLogout()
    }
    
    func fetchStats() throws -> (totalQuizzes: Int, avgScore: Double, bestScores: Double, totalQuestions: Int) {
        let results = try storageService.fetchResults()
        let totalQuizzes = results.count
        let avgScore = results.isEmpty ? 0.0 : results.map { $0.percentage }.reduce(0.0, +) / Double(totalQuizzes)
        let bestScores = results.map(\.percentage).max() ?? 0.0
        let totalQuestions = results.map { $0.totalQuestions }.reduce(0,+)
        return (totalQuizzes, avgScore, bestScores, totalQuestions)
    }
    
    func clearData() {
        do {
            try storageService.deleteAll()
        } catch {
            onError?(error.localizedDescription)
        }
    }
}
