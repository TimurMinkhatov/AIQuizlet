//
//  HomeCoordinator.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 01/04/2026.
//  Copyright © 2026 t-bank-team-practice. All rights reserved.
//

import UIKit

final class HomeCoordinator: Coordinator {

    // MARK: - Properties

    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController

    // MARK: - Init

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Coordinator

    func start() {
        showHome()
    }

}

// MARK: - Private Methods

private extension HomeCoordinator {

    func showTextInput() {
        let quizCoordinator = QuizCoordinator(navigationController: navigationController)
        quizCoordinator.parentCoordinator = self
        children.append(quizCoordinator)
        quizCoordinator.start()
    }

    func showHome() {
        let vm = HomeViewModel()
        vm.coordinator = self
        let vc = HomeViewController(viewModel: vm)
        navigationController.setViewControllers([vc], animated: false)
    }
}
