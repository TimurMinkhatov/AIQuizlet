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
        showQuiz(quiz: quiz)
    }

    func didCapturePhoto(_ image: UIImage) {
        showPhotoPreview(with: image)
    }
}

// MARK: - Navigation Methods

extension QuizCoordinator {

    func showTextInput() {
        let quizService = QuizService(networkManager: NetworkManager())
        let vm = TextInputViewModel(quizService: quizService)
        vm.coordinator = self
        let vc = TextInputViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }

    func showPhotoFlow() {
        let cameraService = CameraService()
        let vm = CameraViewModel(cameraService: cameraService)
        vm.coordinator = self
        let vc = CameraViewController(viewModel: vm)
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }

    func showQuiz(quiz: Quiz) {
        let quizService = QuizService(networkManager: NetworkManager())
        let vm = QuizViewModel(quizService: quizService)
        vm.setQuiz(quiz)
        let vc = QuizViewController(viewModel: vm)
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
}

// MARK: - Private Methods

private extension QuizCoordinator {

    func showPhotoPreview(with image: UIImage) {
        let vc = PhotoPreviewViewController(image: image)

        vc.onContinue = { [weak self] selectedCount in
            self?.proccessImageToQuiz(image, count: selectedCount)
        }

        vc.onRetake = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }

        navigationController.pushViewController(vc, animated: true)
    }

    func proccessImageToQuiz(_ image: UIImage, count: Int) {
        let recognitionService = TextRecognitionService()
        let quizService = QuizService(networkManager: NetworkManager())

        recognitionService.recognizeText(from: image) { [weak self] text in
            guard let self = self, let recognizedText = text, !recognizedText.isEmpty else {
                return
            }

            Task {
                do {
                    let quiz = try await quizService.generateQuiz(for: recognizedText, count: count)
                    await MainActor.run {
                        self.showQuiz(quiz: quiz)
                    }
                } catch {
                    await MainActor.run {
                        print("Ошибка генерации: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
