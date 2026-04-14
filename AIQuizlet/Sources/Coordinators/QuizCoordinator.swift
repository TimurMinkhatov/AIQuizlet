//
//  QuizCoordinator.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 13/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit

final class QuizCoordinator: Coordinator {

    // MARK: - Properties

    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController

    // MARK: - Init

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Coordinator

    func start() {
        showTextInput()
    }
}

// MARK: - Private Methods

private extension QuizCoordinator {

    func showTextInput() {
        let quizService = QuizService(networkManager: NetworkManager())
        let vm = TextInputViewModel(quizService: quizService)
        vm.coordinator = self
        let vc = TextInputViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
}
