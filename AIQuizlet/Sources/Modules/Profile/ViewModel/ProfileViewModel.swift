//
//  ProfileViewModel.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 25/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation

struct ProfileStats {
    let totalQuizzes: Int
    let avgScore: Double
    let bestScore: Double
    let totalQuestions: Int
}

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
    
    func fetchStats() async throws -> ProfileStats {
        if let user = try await firestoreService.fetchUser() {
            return ProfileStats(
                totalQuizzes: user.stats.totalQuizzes,
                avgScore: user.stats.averageScore,
                bestScore: user.stats.bestScore,
                totalQuestions: user.stats.totalCompleted
            )
        }
        
        guard let userId = authService.currentUser?.uid, !userId.isEmpty else {
            return ProfileStats(totalQuizzes: 0, avgScore: 0, bestScore: 0, totalQuestions: 0)
        }
        
        let results = try storageService.fetchResults().filter { $0.userId == userId }
        let totalQuizzes = results.count
        let avgScore = results.isEmpty ? 0.0 : results.map { $0.percentage }.reduce(0.0, +) / Double(totalQuizzes)
        let bestScore = results.map(\.percentage).max() ?? 0.0
        let totalQuestions = results.map { $0.totalQuestions }.reduce(0, +)
        
        return ProfileStats(
            totalQuizzes: totalQuizzes,
            avgScore: avgScore,
            bestScore: bestScore,
            totalQuestions: totalQuestions
        )
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
