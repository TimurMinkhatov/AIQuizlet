//
//  AuthCoordinator.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 01/04/2026.
//  Copyright © 2026 t-bank-team-practice. All rights reserved.
//

import UIKit

final class AuthCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showRegister()
    }

    func showLogin() {
        let vm = LoginViewModel()
        vm.coordinator = self
        let vc = LoginViewController(viewModel: vm)
        navigationController.setViewControllers([vc], animated: false)
    }

    func showRegister() {
        let vm = RegisterViewModel()
        vm.coordinator = self
        let vc = RegisterViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }

    func didFinishAuth() {
        guard let appCoordinator = parentCoordinator as? AppCoordinator else { return }
        appCoordinator.children.removeAll { $0 === self }
        appCoordinator.showHome()
    }
}
