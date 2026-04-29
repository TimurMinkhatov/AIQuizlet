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
    
    func didRequestRetake() {
        navigationController.popViewController(animated: true)
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
    
    
    
    func handlePhotoGeneration(image: UIImage, count: Int, for vc: PhotoPreviewViewController) {
        self.processImageToQuiz(image, count: count) { [weak vc] result in
            DispatchQueue.main.async {
                vc?.stopLoading()
                
                if case .failure(let error) = result {
                    vc?.showError(error.localizedDescription)
                }
            }
        }
    }

    func processImageToQuiz(_ image: UIImage, count: Int, completion: @escaping (Result<Quiz, Error>) -> Void) {
        let recognitionService = TextRecognitionService()
        let quizService = QuizService(networkManager: NetworkManager())

        recognitionService.recognizeText(from: image) { [weak self] text in
            guard let self = self else { return }
            guard let recognizedText = text, !recognizedText.isEmpty else {
                let error = NSError(domain: "QuizError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Не удалось распознать текст на фото. Попробуйте сделать более четкий снимок."])
                completion(.failure(error))
                return
            }

            Task {
                do {
                    let quiz = try await quizService.generateQuiz(for: recognizedText, count: count)
                    await MainActor.run {
                        completion(.success(quiz))
                        self.showQuiz(quiz: quiz)
                    }
                } catch {
                    await MainActor.run {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
