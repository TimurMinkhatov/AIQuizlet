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
    private weak var currentQuizViewModel: QuizViewModel?

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
        guard let currentUserId = AuthService.shared.currentUser?.uid, !currentUserId.isEmpty else {
            return
        }
        let questionRecords = quiz.questions.enumerated().map { index, question in
            QuestionRecord(
                orderIndex: index,
                text: question.text,
                answers: question.answers,
                correctAnswer: question.correctAnswer,
                explanation: question.explanation
            )
        }
        let record = QuizRecord(
                userId: currentUserId,
                title: quiz.title,
                questions: questionRecords
            )
        DispatchQueue.main.async { [weak self] in
            self?.showQuiz(quiz: quiz, record: record)
        }
    }

    func didCapturePhoto(_ image: UIImage) {
        showPhotoPreview(with: image)
    }
}

// MARK: - Navigation Methods

extension QuizCoordinator {
    
    func showTextInput() {
        let viewModel = TextInputViewModel(quizService: servicesAssembly.quizService)
        viewModel.coordinator = self
        let viewController = TextInputViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showPhotoFlow() {
        let viewModel = CameraViewModel(cameraService: servicesAssembly.cameraService)
        viewModel.coordinator = self
        let viewController = CameraViewController(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showQuiz(quiz: Quiz, record: QuizRecord) {
        let viewModel = QuizViewModel(
            quizService: servicesAssembly.quizService,
            firestoreService: servicesAssembly.firestoreService,
            storageService: servicesAssembly.storageService
        )
        viewModel.coordinator = self
        viewModel.setQuiz(quiz, record: record)
        currentQuizViewModel = viewModel
        let viewController = QuizViewController(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func didRequestRetake() {
        navigationController.popViewController(animated: true)
    }
    
    func showResult(with result: QuizResult) {
        let viewModel = QuizResultViewModel(
            quizResult: result,
            onRetry: { [weak self] quizRecord in
                self?.currentQuizViewModel?.restart()
                self?.navigationController.popViewController(animated: true)
            },
            onHome: { [weak self] in
                self?.navigationController.popToRootViewController(animated: true)
            }
        )
        
        let viewController = QuizResultViewController(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func finishFlow() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func startQuiz(with record: QuizRecord) {
        let viewModel = QuizViewModel(
            quizService: servicesAssembly.quizService,
            firestoreService: servicesAssembly.firestoreService,
            storageService: servicesAssembly.storageService
        )
        viewModel.coordinator = self
        let viewController = QuizViewController(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true
        viewModel.loadFromRecord(record)
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - Private Methods

private extension QuizCoordinator {
    
    func showPhotoPreview(with image: UIImage) {
        let viewModel = PhotoPreviewViewModel(image: image)
        let viewController = PhotoPreviewViewController(viewModel: viewModel)
        viewModel.coordinator = self
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
