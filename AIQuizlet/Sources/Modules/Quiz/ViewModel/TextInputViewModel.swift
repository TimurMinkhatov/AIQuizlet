//
//  TextInputViewModel.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 13/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation

final class TextInputViewModel {

    // MARK: - State Enum

    enum State {
        case idle
        case loading
        case error(String)
    }

    // MARK: - Properties
    
    weak var coordinator: QuizCoordinator?
    var onStateChange: ((State) -> Void)?

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
        
        onStateChange?(.loading)

        Task {
            do {
                let quiz = try await quizService.generateQuiz(for: text, count: questionCount)
                await MainActor.run {
                    self.onStateChange?(.idle)
                    self.coordinator?.didGenerateQuiz(quiz)
                }
            } catch {
                await MainActor.run {
                    self.onStateChange?(.error(error.localizedDescription))
                }
            }
        }
    }
}
