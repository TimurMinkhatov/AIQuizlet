//
//  HistoryCoordinator.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 05.05.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit

final class HistoryCoordinator: Coordinator {
    
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
    
    // MARK: - Public Methods
    
    func start() {
        Task { @MainActor in
            let viewModel = HistoryViewModel(servicesAssembly: servicesAssembly)
            viewModel.coordinator = self
            let viewController = HistoryViewController(viewModel: viewModel)
            navigationController.pushViewController(viewController, animated: false)
        }
    }
    
    func showResultDetail(for result: QuizResult) {
        Task { @MainActor in
            let viewModel = QuizResultViewModel(
                quizResult: result,
                isFromHistory: true,
                onRetry: { [weak self] quizRecord in
                    self?.startRetryQuiz(with: quizRecord)
                },
                onHome: { [weak self] in
                    self?.navigateToHome()
                }
            )
            
            let viewController = QuizResultViewController(viewModel: viewModel)
            viewController.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK: - Private Methods
    
    private func navigateToHome() {
        navigationController.popToRootViewController(animated: true)
        if let tabBarCoordinator = parentCoordinator as? TabBarCoordinator {
            tabBarCoordinator.tabBarController.selectedIndex = TabBarPage.home.rawValue
        }
    }
    
    private func startRetryQuiz(with quiz: QuizRecord) {
        let quizCoordinator = QuizCoordinator(
            navigationController: navigationController,
            servicesAssembly: servicesAssembly
        )
        quizCoordinator.parentCoordinator = self
        children.append(quizCoordinator)
        quizCoordinator.startQuiz(with: quiz)
    }
}
