//
//  HomeCoordinator.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 01/04/2026.
//  Copyright © 2026 t-bank-team-practice. All rights reserved.
//

import UIKit

final class HomeCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = HomeViewModel()
        viewModel.coordinator = self
        let viewController = HomeViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }
}

extension HomeCoordinator {
    func showProfile() {
        if let tabBarCoordinator = parentCoordinator as? TabBarCoordinator {
            tabBarCoordinator.showProfileTab()
        }
    }

    func showTextInput() {
        let quizCoordinator = QuizCoordinator(navigationController: navigationController)
        quizCoordinator.parentCoordinator = self
        children.append(quizCoordinator)
        quizCoordinator.start()
    }
    
}
