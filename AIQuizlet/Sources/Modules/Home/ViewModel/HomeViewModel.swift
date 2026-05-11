//
//  HomeViewModel.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 07/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation

struct RecentTest {
    let title: String
    let date: Date
    let percentage: Double
}

final class HomeViewModel {

    // MARK: - Properties

    weak var coordinator: HomeCoordinator?
    private let authService: AuthServiceProtocol
    private let storageService: StorageServiceProtocol
    private var fullResults: [QuizResult] = []
    var recentTests: [RecentTest] = []
    var onDataUpdated: (() -> Void)?

    // MARK: - Init
    
    init(
        authService: AuthServiceProtocol,
        storageService: StorageServiceProtocol
    ) {
        self.authService = authService
        self.storageService = storageService
    }

    // MARK: - Public Methods
    
    func fetchRecentTests() {
        guard let userId = authService.currentUserId, !userId.isEmpty else {
            self.fullResults = []
            self.recentTests = []
            onDataUpdated?()
            return
        }
        do {
            let results = try storageService.fetchResults()
                .filter { $0.userId == userId }
            let sortedResults = results.sorted(by: { $0.date > $1.date })
            let topThree = Array(sortedResults.prefix(3))
            
            self.fullResults = topThree
            
            self.recentTests = topThree.map { result in
                RecentTest(
                    title: result.quiz.title,
                    date: result.date,
                    percentage: result.percentage
                )
            }
            onDataUpdated?()
        } catch {
            self.recentTests = []
            self.fullResults = []
            onDataUpdated?()
        }
    }
    
    func seeAllRecentTestsSelected() {
        coordinator?.showHistory()
    }
    
    func didSelectRecentTest(at index: Int) {
        guard index < fullResults.count else { return }
        let selectedResult = fullResults[index]
        coordinator?.showResultDetail(for: selectedResult)
    }

    func profileSelected() {
        coordinator?.showProfile()
    }

    func textInputSelected() {
        coordinator?.showTextInput()
    }

    func photoInputSelected() {
        coordinator?.showPhotoInput()
    }
}
