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

    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    let servicesAssembly: ServicesAssembly

    // MARK: - Init

    init(navigationController: UINavigationController, servicesAssembly: ServicesAssembly) {
        self.navigationController = navigationController
        self.servicesAssembly = servicesAssembly
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
        let authViewModel = AuthViewModel(
            authService: servicesAssembly.authService,
            firestoreService: servicesAssembly.firestoreService
        )
        authViewModel.coordinator = self
        let authViewController = AuthViewController(viewModel: authViewModel)
        navigationController.setViewControllers([authViewController], animated: false)
    }
}
