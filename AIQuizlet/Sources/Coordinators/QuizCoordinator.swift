//
//  QuizCoordinator.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 27.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit

final class QuizCoordinator: Coordinator {

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

    // MARK: - Coordinator

    func start() {
        showTextInput()
    }

    // MARK: - Public Methods

    func didGenerateQuiz(_ quiz: Quiz) {
        showQuiz(quiz: quiz)
    }

    func didCapturePhoto(_ image: UIImage) {
        showPhotoPreview(with: image)
    }
}

// MARK: - Navigation Methods

extension QuizCoordinator {

    func showTextInput() {
        let vm = TextInputViewModel(quizService: servicesAssembly.quizService)
        vm.coordinator = self
        let vc = TextInputViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }

    func showPhotoFlow() {
        let vm = CameraViewModel(cameraService: servicesAssembly.cameraService)
        vm.coordinator = self
        let vc = CameraViewController(viewModel: vm)
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }

    func showQuiz(quiz: Quiz) {
        let vm = QuizViewModel(quizService: servicesAssembly.quizService)
        vm.setQuiz(quiz)
        let vc = QuizViewController(viewModel: vm)
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func didRequestRetake() {
        navigationController.popViewController(animated: true)
    }
}

// MARK: - Private Methods

private extension QuizCoordinator {
    
    func showPhotoPreview(with image: UIImage) {
        let vm = PhotoPreviewViewModel(image: image)
        let vc = PhotoPreviewViewController(viewModel: vm)
        vm.coordinator = self
        
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
        
    }
}
