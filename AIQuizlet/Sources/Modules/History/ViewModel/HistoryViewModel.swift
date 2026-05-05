//
//  HistoryViewModel.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 05.05.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation

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
    
    func fetchHistory() {
        do {
            let results = try servicesAssembly.storageService.fetchResults()
            self.allResults = results.sorted(by: { $0.date > $1.date })
            self.filteredResults = self.allResults
        } catch {
            self.filteredResults = []
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
}
