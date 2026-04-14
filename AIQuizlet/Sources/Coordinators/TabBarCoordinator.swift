//
//  TabBarCoordinator.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 13.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit


final class TabBarCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    var children = [Coordinator]()
    var parentCoordinator: Coordinator?
    var tabBarController: UITabBarController
    
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }
    
    // MARK: - Public Methods
    
    func start() {
        let pages = TabBarPage.allCases.sorted { $0.rawValue < $1.rawValue }
        let controllers = TabBarPage.allCases.map { getTabController($0)}
        
        prepareTabBarController(with: controllers)
    }
    
    func showProfileTab() {
        tabBarController.selectedIndex = TabBarPage.profile.rawValue
    }
}


    // MARK: - Private Methods

private extension TabBarCoordinator {
    
    func prepareTabBarController(with controllers: [UIViewController]) {
        tabBarController.setViewControllers(controllers, animated: false)
        tabBarController.selectedIndex = TabBarPage.home.rawValue
        
        tabBarController.tabBar.backgroundColor = .white
        
        tabBarController.tabBar.tintColor = UIColor(red: 152/255, green: 16/255, blue: 250/255, alpha: 1)
        
    }
    
    func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = UITabBarItem(
            title: page.pageTitle,
            image: UIImage(systemName: page.pageIconName),
            tag: page.rawValue
        )
        
        switch page {
        case .home:
            let homeCoordinator = HomeCoordinator(navigationController: navigationController)
            homeCoordinator.parentCoordinator = self
            children.append(homeCoordinator)
            homeCoordinator.start()
            
        case .history:
            let viewController = UIViewController()
            viewController.view.backgroundColor = .white
            viewController.title = "История"
            navigationController.pushViewController(viewController, animated: false)
        case .profile:
            let viewController = UIViewController()
            viewController.view.backgroundColor = .white
            viewController.title = "Профиль"
            navigationController.pushViewController(viewController, animated: false)
        }
        
        return navigationController

    }
}
