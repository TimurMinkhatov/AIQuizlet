//
//  HomeViewModel.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 07/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation

// MARK: - RecentTest Model

struct RecentTest {
    let title: String
    let score: String
}

// MARK: - HomeViewModel

final class HomeViewModel {

    // MARK: - Properties

    weak var coordinator: HomeCoordinator?
    
    let recentTests: [RecentTest] = []

    // MARK: - Public Methods

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
