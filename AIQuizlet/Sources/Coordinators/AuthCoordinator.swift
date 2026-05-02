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
    let assembly: ServicesAssembly

    // MARK: - Init

    init(navigationController: UINavigationController, assembly: ServicesAssembly) {
        self.navigationController = navigationController
        self.assembly = assembly
    }

    // MARK: - Coordinator

    func start() {
        showAuth()
    }

    // MARK: - Public Methods
    
    func didFinishAuth() {
        guard let appCoordinator = parentCoordinator as? AppCoordinator else { return }
        appCoordinator.children.removeAll { $0 === self }
        appCoordinator.showMainFlow()
    }
}

// MARK: - Private Methods

private extension AuthCoordinator {

    func showAuth(state: AuthState = .login) {
        let vm = AuthViewModel(assembly: assembly)
        vm.coordinator = self
        let vc = AuthViewController(viewModel: vm)
        navigationController.setViewControllers([vc], animated: false)
    }
}
