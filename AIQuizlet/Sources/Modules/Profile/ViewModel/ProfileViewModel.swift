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
    private let servicesAssembly: ServicesAssembly
    var onError: ((String) -> Void)?
    var email: String = AuthService.shared.currentUser?.email ?? "Unknown"
    
    
    // MARK: - Init
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    // MARK: - Public Methods
    
    func logout() {
        AuthService.shared.signOut()
        coordinator?.didLogout()
    }
    
    func fetchStats() async throws -> (totalQuizzes: Int, avgScore: Double, bestScores: Double, totalQuestions: Int) {
        if let user = try await servicesAssembly.firestoreService.fetchUser() {
            return (user.totalQuizzes, user.averageScore, user.bestScore, user.totalCompleted)
        }
        
        let results = try servicesAssembly.storageService.fetchResults()
        let totalQuizzes = results.count
        let avgScore = results.isEmpty ? 0.0 : results.map { $0.percentage }.reduce(0.0, +) / Double(totalQuizzes)
        let bestScores = results.map(\.percentage).max() ?? 0.0
        let totalQuestions = results.map { $0.totalQuestions }.reduce(0,+)
        return (totalQuizzes, avgScore, bestScores, totalQuestions)
    }
    
    func clearData() {
        do {
            try servicesAssembly.storageService.deleteAll()
            Task {
                try? await servicesAssembly.firestoreService.deleteAllData()
            }
        } catch {
            onError?(error.localizedDescription)
        }
    }
}
