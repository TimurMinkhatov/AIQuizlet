//
//  HomeCoordinator.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 01/04/2026.
//  Copyright © 2026 t-bank-team-practice. All rights reserved.
//

import UIKit

final class HomeCoordinator: Coordinator {
    
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
        let viewModel = HomeViewModel(servicesAssembly: servicesAssembly)
        viewModel.coordinator = self
        let viewController = HomeViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }
}

// MARK: - Navigation

extension HomeCoordinator {
    
    func showProfile() {
        if let tabBarCoordinator = parentCoordinator as? TabBarCoordinator {
            tabBarCoordinator.showProfileTab()
        }
    }
    
    func showTextInput() {
        let quizCoordinator = QuizCoordinator(
            navigationController: navigationController,
            servicesAssembly: servicesAssembly
        )
        quizCoordinator.parentCoordinator = self
        children.append(quizCoordinator)
        quizCoordinator.start()
    }
    
    func showPhotoInput() {
        let quizCoordinator = QuizCoordinator(
            navigationController: navigationController,
            servicesAssembly: servicesAssembly
        )
        quizCoordinator.parentCoordinator = self
        children.append(quizCoordinator)
        quizCoordinator.showPhotoFlow()
    }
    
    func showHistory() {
        if let tabBarCoordinator = parentCoordinator as? TabBarCoordinator {
            tabBarCoordinator.showHistoryTab()
        }
    }
    
    func showResultDetail(for result: QuizResult) {
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
    
    // MARK: - Private Methods
    
    private func navigateToHome() {
        navigationController.popToRootViewController(animated: true)
    }
    
    private func startRetryQuiz(with quiz: QuizRecord) {
        children.removeAll(where: { $0 is QuizCoordinator })
        let quizCoordinator = QuizCoordinator(
            navigationController: navigationController,
            servicesAssembly: servicesAssembly
        )
        quizCoordinator.parentCoordinator = self
        children.append(quizCoordinator)
        quizCoordinator.startQuiz(with: quiz)
    }
}
