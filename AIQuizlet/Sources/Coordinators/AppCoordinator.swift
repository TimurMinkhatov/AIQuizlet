//
//  AppCoordinator.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 01/04/2026.
//  Copyright © 2026 t-bank-team-practice. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftData

final class AppCoordinator: Coordinator {

    // MARK: - Properties

    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private var window: UIWindow?
    private let servicesAssembly: ServicesAssembly

    // MARK: - Init
    
    init(navigationController: UINavigationController, window: UIWindow?, servicesAssembly: ServicesAssembly) {
        self.navigationController = navigationController
        self.window = window
        self.servicesAssembly = servicesAssembly
    }

    // MARK: - Public Methods
    
    func start() {
        if Auth.auth().currentUser != nil {
            showAuth()
        } else {
            showAuth()
        }
    }
    
    func showAuth() {
        children.removeAll()
        
        let authCoordinator = AuthCoordinator(navigationController: navigationController, servicesAssembly: servicesAssembly)
        authCoordinator.parentCoordinator = self
        children.append(authCoordinator)
        authCoordinator.start()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func showMainFlow() {
        children.removeAll()

        let tabBarCoordinator = TabBarCoordinator(
            navigationController: navigationController,
            assembly: servicesAssembly
        )
        tabBarCoordinator.parentCoordinator = self
        children.append(tabBarCoordinator)
        tabBarCoordinator.start()

        window?.rootViewController = navigationController  
        window?.makeKeyAndVisible()
    }
}
