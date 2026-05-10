//
//  HistoryViewModel.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 05.05.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation

@MainActor
final class HistoryViewModel {
    
    // MARK: - Properties
    
    weak var coordinator: HistoryCoordinator?
    private let servicesAssembly: ServicesAssembly
    
    private var allResults: [QuizResult] = []
    
    var filteredResults: [QuizResult] = [] {
        didSet {
            onDataUpdated?()
        }
    }
    
    var onDataUpdated: (() -> Void)?
    
    // MARK: - Init
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    // MARK: - Public Methods
    private var hasCleanedUp = false

    func fetchHistory() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let currentUserId = try await self.servicesAssembly.authService.requireUserId()
                
                self.loadLocalData(userId: currentUserId)
                await self.syncWithFirestore(userId: currentUserId)
                
                if !self.hasCleanedUp {
                    await self.cleanupOrphanResults()
                    self.hasCleanedUp = true
                    
                    await MainActor.run {
                        self.loadLocalData(userId: currentUserId)
                    }
                }
            } catch {
                self.filteredResults = []
            }
        }
    }
    
    func search(query: String) {
        if query.isEmpty {
            filteredResults = allResults
        } else {
            filteredResults = allResults.filter { result in
                result.quiz.title.localizedCaseInsensitiveContains(query)
            }
        }
    }
    
    func didSelectTest(at index: Int) {
        let selectedResult = filteredResults[index]
        coordinator?.showResultDetail(for: selectedResult)
    }
    
    func cleanupOrphanResults() async {
        let userId: String
        do {
            userId = try await servicesAssembly.authService.requireUserId()
        } catch {
            return
        }
        
        do {
            let cloudResults = try await servicesAssembly.firestoreService.fetchUserResults(userId: userId)
            let cloudQuizzes = try await servicesAssembly.firestoreService.fetchUserQuizzes(userId: userId)
            
            guard !cloudQuizzes.isEmpty else {
                return
            }
            
            let validQuizIds = Set(cloudQuizzes.map { $0.id })
            
            var deletedCount = 0
            for result in cloudResults where !validQuizIds.contains(result.quizId) {
                try await servicesAssembly.firestoreService.deleteQuizResult(resultId: result.id)
                deletedCount += 1
            }
        } catch {
        }
    }
    
    // MARK: - Private Methods
    
    private func loadLocalData(userId: String) {
        do {
            let results = try servicesAssembly.storageService.fetchResults()
            self.allResults = results
                .filter { $0.userId == userId }
                .sorted(by: { $0.date > $1.date })
            self.filteredResults = self.allResults
        } catch {
            self.filteredResults = []
        }
    }
    
    private func syncWithFirestore(userId: String) async {
        do {
            let cloudQuizzes = try await servicesAssembly.firestoreService.fetchUserQuizzes(userId: userId)
            var syncedQuizIds = Set<String>()
            
            for fsQuiz in cloudQuizzes {
                let exists = try servicesAssembly.storageService.checkExists(id: fsQuiz.id)
                if !exists {
                    try servicesAssembly.storageService.saveCloudQuiz(fsQuiz, userId: userId)
                }
                syncedQuizIds.insert(fsQuiz.id)
            }
            
            let cloudResults = try await servicesAssembly.firestoreService.fetchUserResults(userId: userId)
            
            var syncedResultsCount = 0
            var orphanResultsCount = 0
            
            for fsResult in cloudResults {
                if syncedQuizIds.contains(fsResult.quizId) {
                    let resultExists = try servicesAssembly.storageService.checkResultExists(id: fsResult.id)
                    if !resultExists {
                        try servicesAssembly.storageService.saveCloudResult(fsResult, userId: userId)
                        syncedResultsCount += 1
                    }
                } else {
                    orphanResultsCount += 1
                }
            }
            
            await MainActor.run {
                self.loadLocalData(userId: userId)
            }
        } catch {
        }
    }
}
