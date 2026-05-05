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
    private let servicesAssembly: ServicesAssembly
    private var fullResults: [QuizResult] = []
    var recentTests: [RecentTest] = []
    var onDataUpdated: (() -> Void)?

    // MARK: - Init
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    // MARK: - Public Methods
    
    func fetchRecentTests() {
        do {
            let results = try servicesAssembly.storageService.fetchResults()
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
