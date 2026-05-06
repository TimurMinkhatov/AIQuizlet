//
//  HistoryCoordinator.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 05.05.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit

final class HistoryCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let servicesAssembly: ServicesAssembly
    
    init(navigationController: UINavigationController, servicesAssembly: ServicesAssembly) {
        self.navigationController = navigationController
        self.servicesAssembly = servicesAssembly
    }
    
    func start() {
        let viewModel = HistoryViewModel(servicesAssembly: servicesAssembly)
        viewModel.coordinator = self
        let viewController = HistoryViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showResultDetail(for result: QuizResult) {
        let viewModel = QuizResultViewModel(quizResult: result, isFromHistory: true)
        let viewController = QuizResultViewController(viewModel: viewModel)
        
        viewModel.onHome = { [weak self] in
            self?.navigationController.popToRootViewController(animated: true)
            if let tabBarCoordinator = self?.parentCoordinator as? TabBarCoordinator {
                tabBarCoordinator.tabBarController.selectedIndex = TabBarPage.home.rawValue
            }
        }
        
        viewModel.onRetry = { [weak self] in
            guard let self = self else { return }
            let quizCoordinator = QuizCoordinator(navigationController: self.navigationController, servicesAssembly: self.servicesAssembly)
            quizCoordinator.parentCoordinator = self
            self.children.append(quizCoordinator)
            quizCoordinator.startQuiz(with: result.quiz)
        }
        
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
