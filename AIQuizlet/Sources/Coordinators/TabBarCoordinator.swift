//
//  TabBarCoordinator.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 13.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SwiftData

final class TabBarCoordinator: Coordinator {
    var navigationController: UINavigationController
    var children = [Coordinator]()
    var parentCoordinator: Coordinator?
    var tabBarController: UITabBarController
    let modelContainer: ModelContainer
    
    init(navigationController: UINavigationController, modelContainer: ModelContainer) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
        self.modelContainer = modelContainer
    }
    
    func start() {
        let pages = TabBarPage.allCases.sorted { $0.rawValue < $1.rawValue }
        let controllers = pages.map { createNavViewController(for: $0) }
        
        prepareTabBarController(with: controllers)
        pages.forEach { launchCoordinator(for: $0) }
    }
    
    func showProfileTab() {
        tabBarController.selectedIndex = TabBarPage.profile.rawValue
    }
}

// MARK: - Private Methods

private extension TabBarCoordinator {
    
    func createNavViewController(for page: TabBarPage) -> UINavigationController {
        let nav = UINavigationController()
        nav.tabBarItem = UITabBarItem(
            title: page.pageTitle,
            image: UIImage(systemName: page.pageIconName),
            tag: page.rawValue
        )
        return nav
    }
    
    func launchCoordinator(for page: TabBarPage) {
        guard let nav = tabBarController.viewControllers?[page.rawValue] as? UINavigationController else { return }
        
        switch page {
        case .home:
            let homeCoordinator = HomeCoordinator(navigationController: nav)
            homeCoordinator.parentCoordinator = self
            children.append(homeCoordinator)
            homeCoordinator.start()
        case .history:
            let historyViewController = UIViewController()
            historyViewController.view.backgroundColor = .white
            historyViewController.title = "История"
            nav.setViewControllers([historyViewController], animated: false)
        case .profile:
            let profileViewController = UIViewController()
            profileViewController.view.backgroundColor = .white
            profileViewController.title = "Профиль"
            nav.setViewControllers([profileViewController], animated: false)
        }
    }
    
    func prepareTabBarController(with controllers: [UIViewController]) {
        tabBarController.setViewControllers(controllers, animated: false)
        tabBarController.selectedIndex = TabBarPage.home.rawValue
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.tintColor = UIColor(red: 152/255, green: 16/255, blue: 250/255, alpha: 1) 
        navigationController.viewControllers = [tabBarController]
        navigationController.setNavigationBarHidden(true, animated: false)
        setupAppearance()
    }
    
    func setupAppearance() {
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            tabBarController.tabBar.standardAppearance = appearance
            tabBarController.tabBar.scrollEdgeAppearance = appearance
        }
    }
}
