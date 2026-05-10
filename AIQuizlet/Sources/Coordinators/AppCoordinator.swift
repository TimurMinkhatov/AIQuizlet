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

    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private var window: UIWindow?
    private let servicesAssembly: ServicesAssembly

    private var authChecked = false
    private var timerDone = false
    private var authUser: FirebaseAuth.User?

    // MARK: - Init

    init(navigationController: UINavigationController, window: UIWindow?, servicesAssembly: ServicesAssembly) {
        self.navigationController = navigationController
        self.window = window
        self.servicesAssembly = servicesAssembly
    }

    // MARK: - Public Methods

    func start() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.timerDone = true
            self?.tryTransition()
        }

        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.authUser = user
            self?.authChecked = true
            self?.tryTransition()
        }
    }
    
    func restartWithoutSplash() {
        if servicesAssembly.authService.currentUser != nil {
            showMainFlow()
        } else {
            showAuth()
        }
    }

    func showAuth() {
        children.removeAll()

        let authCoordinator = AuthCoordinator(
            navigationController: navigationController,
            servicesAssembly: servicesAssembly
        )
        authCoordinator.parentCoordinator = self
        children.append(authCoordinator)
        authCoordinator.start()
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

// MARK: - Private Methods

private extension AppCoordinator {

    func tryTransition() {
        guard authChecked && timerDone else { return }
        DispatchQueue.main.async { [weak self] in
            if self?.authUser != nil {
                self?.showMainFlow()
            } else {
                self?.showAuth()
            }
        }
    }
}
