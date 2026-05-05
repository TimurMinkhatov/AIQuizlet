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
    private let firestoreService: FirestoreService
    private let storageService: StorageService
    private let authService: AuthService
    var onError: ((String) -> Void)?
    var email: String {
        return authService.currentUser?.email ?? "Unknown"
    }
    
    // MARK: - Init
    
    init(
        firestoreService: FirestoreService,
        storageService: StorageService,
        authService: AuthService
    ) {
        self.firestoreService = firestoreService
        self.storageService = storageService
        self.authService = authService
    }
    
    // MARK: - Public Methods
    
    func logout() {
        authService.signOut()
        coordinator?.didLogout()
    }

    
    func fetchStats() async throws -> (totalQuizzes: Int, avgScore: Double, bestScores: Double, totalQuestions: Int) {
        if let user = try await firestoreService.fetchUser() {
            return (user.stats.totalQuizzes, user.stats.averageScore, user.stats.bestScore, user.stats.totalCompleted)
        }
        
        guard let userId = authService.currentUser?.uid, !userId.isEmpty else {
            return (0, 0, 0, 0)
        }
        let results = try storageService.fetchResults().filter { $0.userId == userId }
        let totalQuizzes = results.count
        let avgScore = results.isEmpty ? 0.0 : results.map { $0.percentage }.reduce(0.0, +) / Double(totalQuizzes)
        let bestScores = results.map(\.percentage).max() ?? 0.0
        let totalQuestions = results.map { $0.totalQuestions }.reduce(0,+)
        return (totalQuizzes, avgScore, bestScores, totalQuestions)
    }
    
    func clearData() {
        do {
            try storageService.deleteAll()
            Task {
                try? await firestoreService.deleteAllData()
            }
        } catch {
            onError?(error.localizedDescription)
        }
    }
}
