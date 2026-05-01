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
    let assembly: ServicesAssembly
    
    // MARK: - Init
    
    init(navigationController: UINavigationController, assembly: ServicesAssembly) {
        self.navigationController = navigationController
        self.assembly = assembly
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
        let vm = ProfileViewModel(assembly: assembly)
        vm.coordinator = self
        let vc = ProfileViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
}
