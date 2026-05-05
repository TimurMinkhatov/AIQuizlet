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
    
    weak var coordinator: QuizCoordinator?
    let image: UIImage
    private let recognitionService: TextRecognitionService
    private let quizService: QuizService
    
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onErrorOccurred: ((String) -> Void)?
    var onSuccess: ((Quiz, QuizRecord) -> Void)?
    
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
                        let questionRecords = quiz.questions.toQuestionRecords()
                        let record = QuizRecord(title: quiz.title, questions: questionRecords)
                        
                        self.onLoadingStateChanged?(false)

                        self.coordinator?.showQuiz(quiz: quiz, record: record)
                    }
                } catch {
                    await MainActor.run {
                        self.handleError(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func didRequestRetake() {
        coordinator?.didRequestRetake()
    }
}
    // MARK: - Private Methods
    
private extension PhotoPreviewViewModel {
    func handleError(_ message: String) {
        onLoadingStateChanged?(false)
        onErrorOccurred?(message)
    }
    
    func handleSuccess(quiz: Quiz) {
        
        let questionRecord = quiz.questions.enumerated().map { index, question in
            QuestionRecord(
                orderIndex: index,
                text: question.text,
                answers: question.answers,
                correctAnswer: question.correctAnswer,
                explanation: question.explanation,
            )
        }
        
        let record = QuizRecord(title: quiz.title, questions: questionRecord)
        coordinator?.showQuiz(quiz: quiz, record: record)
    }
}
