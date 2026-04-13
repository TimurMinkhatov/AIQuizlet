//
//  HomeViewModel.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 07/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation

<<<<<<< HEAD
final class HomeViewModel {

    // MARK: - Properties

=======
struct RecentTest {
    let title: String
    let score: String
}

class HomeViewModel {
>>>>>>> dd4b73d (add homeview and add navigation tollbar in app)
    weak var coordinator: HomeCoordinator?
    
    let recentTests: [RecentTest] = [
//        RecentTest(title: "Test 1", score: "80%"),
//        RecentTest(title: "Test 2", score: "80%"),
//        RecentTest(title: "Test 3", score: "80%"),
//        RecentTest(title: "Test 4", score: "80%"),
//        RecentTest(title: "Test 5", score: "80%"),
//        RecentTest(title: "Test 6", score: "80%"),
//        RecentTest(title: "Test 7", score: "80%"),
        ]
    func profileSelected() {
        coordinator?.showProfile()
    }
}

