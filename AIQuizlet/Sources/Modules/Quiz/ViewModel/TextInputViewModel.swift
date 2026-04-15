//
//  TextInputViewModel.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 13/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation

final class TextInputViewModel {

    // MARK: - Properties

    weak var coordinator: QuizCoordinator?
    var onStateChange: ((QuizViewModel.GenerationState) -> Void)?

    private(set) var questionCount: Int = 5
    private(set) var text: String = ""

    private let quizService: QuizServiceProtocol

    // MARK: - Init

    init(quizService: QuizServiceProtocol) {
        self.quizService = quizService
    }

    // MARK: - Public Methods

    func update(text: String) {
        self.text = text
    }

    func update(questionCount: Int) {
        self.questionCount = questionCount
    }

    func generateQuiz() {
        guard !text.isEmpty else { return }
        onStateChange?(.generating)

        Task {
            do {
                let quiz = try await quizService.generateQuiz(for: text)
                await MainActor.run {
                    onStateChange?(.success(quiz))
                }
            } catch {
                await MainActor.run {
                    onStateChange?(.error(error.localizedDescription))
                }
            }
        }
    }
}
