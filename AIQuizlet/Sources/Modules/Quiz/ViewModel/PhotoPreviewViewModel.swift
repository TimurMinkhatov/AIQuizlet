//
//  PhotoPreviewViewModel.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 29.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit

final class PhotoPreviewViewModel {
    
    // MARK: - Properties
    
    let image: UIImage
    private let recognitionService: TextRecognitionService
    private let quizService: QuizService
    
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onErrorOccurred: ((String) -> Void)?
    var onSuccess: ((Quiz) -> Void)?
    
    // MARK: - Init
    
    init(
        image: UIImage,
        recognitionService: TextRecognitionService = TextRecognitionService(),
        quizService: QuizService = QuizService(networkManager: NetworkManager())
    ) {
        self.image = image
        self.recognitionService = recognitionService
        self.quizService = quizService
    }
    
    // MARK: - Public Methods
    
    func generateQuiz(questionsCount: Int) {
        onLoadingStateChanged?(true)
        
        recognitionService.recognizeText(from: image) { [weak self] text in
            guard let self = self else { return }
            
            guard let recognizedText = text, !recognizedText.isEmpty else {
                self.handleError("Не удалось распознать текст на фото. Попробуйте сделать более четкий снимок.")
                return
            }
            
            Task {
                do {
                    let quiz = try await self.quizService.generateQuiz(for: recognizedText, count: questionsCount)
                    await MainActor.run {
                        self.onLoadingStateChanged?(false)
                        self.onSuccess?(quiz)
                    }
                } catch {
                    await MainActor.run {
                        self.handleError(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func handleError(_ message: String) {
        onLoadingStateChanged?(false)
        onErrorOccurred?(message)
    }
}
