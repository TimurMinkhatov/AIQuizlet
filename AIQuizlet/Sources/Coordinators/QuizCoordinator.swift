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
    
    private let networkManager = NetworkManager()
    private lazy var quizService = QuizService(networkManager: networkManager)
    private let cameraService = CameraService()

    // MARK: - Init

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Coordinator

    func start() {
        showTextInput()
    }

    // MARK: - Public Methods

    func didGenerateQuiz(_ quiz: Quiz) {
        
        let questionRecords = quiz.questions.map {
            QuestionRecord(
                text: $0.text,
                answers: $0.answers,
                correctAnswer: $0.correctAnswer,
                explanation: $0.explanation,
                userAnswerIndex: -1
            )
        }
        
        let quizRecord = QuizRecord(
            title: quiz.title,
            questions: questionRecords
        )
        showQuiz(quiz: quiz, record: quizRecord)
    }

    func didCapturePhoto(_ image: UIImage) {
        showPhotoPreview(with: image)
    }
}

// MARK: - Navigation Methods

extension QuizCoordinator {

    func showTextInput() {
        let vm = TextInputViewModel(quizService: quizService)
        vm.coordinator = self
        let vc = TextInputViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }

    func showPhotoFlow() {
        let vm = CameraViewModel(cameraService: cameraService)
        vm.coordinator = self
        let vc = CameraViewController(viewModel: vm)
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }

    func showQuiz(quiz: Quiz, record: QuizRecord) {
        let vm = QuizViewModel(quizService: quizService)
        vm.coordinator = self
        vm.setQuiz(quiz, record: record)
        let vc = QuizViewController(viewModel: vm)
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func didRequestRetake() {
        navigationController.popViewController(animated: true)
    }
    
    func showResult(with result: QuizResult) {
        let vm = QuizResultViewModel(quizResult: result)
        let vc = QuizResultViewController(viewModel: vm)
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func finishFlow() {
        navigationController.popToRootViewController(animated: true)
    }
}

// MARK: - Private Methods

private extension QuizCoordinator {
    
    func showPhotoPreview(with image: UIImage) {
        let vm = PhotoPreviewViewModel(image: image)
        let vc = PhotoPreviewViewController(viewModel: vm)
        vc.coordinator = self
        
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
        
    }
}
