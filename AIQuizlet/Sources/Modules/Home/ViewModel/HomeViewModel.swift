//  Created by Azamat Zakirov on 14.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//


import Foundation

// MARK: - Model

struct RecentTest {
    let title: String
    let score: String
}

final class HomeViewModel {
    
    // MARK: - Properties
    
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
}

// MARK: - Navigation

extension HomeViewModel {
    
    func profileSelected() {
        coordinator?.showProfile()
    }
}

