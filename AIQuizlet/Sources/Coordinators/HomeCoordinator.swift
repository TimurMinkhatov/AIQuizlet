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
<<<<<<< HEAD
        showHome()
    }
}

// MARK: - Private Methods

private extension HomeCoordinator {

    func showHome() {
        let vm = HomeViewModel()
        vm.coordinator = self
        let vc = HomeViewController(viewModel: vm)
        navigationController.setViewControllers([vc], animated: false)
=======
        let viewModel = HomeViewModel()
        viewModel.coordinator = self
        let viewController = HomeViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func showProfile() {
        if let tabBarController = navigationController.tabBarController {
            tabBarController.selectedIndex = 2
        }
>>>>>>> dd4b73d (add homeview and add navigation tollbar in app)
    }
}
