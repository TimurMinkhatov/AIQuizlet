//
//  AuthCoordinator.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 01/04/2026.
//  Copyright © 2026 t-bank-team-practice. All rights reserved.
//

import UIKit

final class AuthCoordinator: Coordinator {

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
        showAuth()
    }

<<<<<<< HEAD
    // MARK: - Public Methods
=======
    func showLogin() {
        let viewModel = LoginViewModel()
        viewModel.coordinator = self
        let viewController = LoginViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }

    func showRegister() {
        let viewModel = RegisterViewModel()
        viewModel.coordinator = self
        let viewController = RegisterViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
>>>>>>> dd4b73d (add homeview and add navigation tollbar in app)

    func didFinishAuth() {
        guard let appCoordinator = parentCoordinator as? AppCoordinator else { return }
        appCoordinator.children.removeAll { $0 === self }
        appCoordinator.showMainFlow()
    }
}

// MARK: - Private Methods

private extension AuthCoordinator {

    func showAuth(state: AuthState = .login) {
        let vm = AuthViewModel()
        vm.coordinator = self
        let vc = AuthViewController(viewModel: vm)
        navigationController.setViewControllers([vc], animated: false)
    }
}
