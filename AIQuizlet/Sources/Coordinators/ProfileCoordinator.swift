//
//  ProfileCoordinator.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 27/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit

final class ProfileCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let servicesAssembly: ServicesAssembly
    
    // MARK: - Init
    
    init(navigationController: UINavigationController, servicesAssembly: ServicesAssembly) {
        self.navigationController = navigationController
        self.servicesAssembly = servicesAssembly
    }
    
    // MARK: - Coordinator
    
    func start() {
        showProfile()
    }
    
    // MARK: - Public Methods
    
    func didLogout() {
        guard let appCoordinator = parentCoordinator?.parentCoordinator as? AppCoordinator else { return }
        appCoordinator.showAuth()
    }
}

// MARK: - Private Methods

private extension ProfileCoordinator {
    
    func showProfile() {
        let profileViewModel = ProfileViewModel(
            firestoreService: servicesAssembly.firestoreService,
            storageService: servicesAssembly.storageService,
            authService: servicesAssembly.authService
        )
        profileViewModel.coordinator = self
        let profileViewController = ProfileViewController(viewModel: profileViewModel)
        navigationController.pushViewController(profileViewController, animated: true)
    }
}
