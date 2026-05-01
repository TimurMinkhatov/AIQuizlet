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
    let assembly: ServicesAssembly
    private var window: UIWindow?

    // MARK: - Init
    
    init(navigationController: UINavigationController, window: UIWindow?, assembly: ServicesAssembly) {
        self.navigationController = navigationController
        self.window = window
        self.assembly = assembly
    }

    // MARK: - Public Methods
    
    func start() {
        if Auth.auth().currentUser != nil {
            showMainFlow()
        } else {
            showAuth()
        }
    }
    
    func showAuth() {
        children.removeAll()
        
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
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
            assembly: assembly
        )
        tabBarCoordinator.parentCoordinator = self
        children.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
}
