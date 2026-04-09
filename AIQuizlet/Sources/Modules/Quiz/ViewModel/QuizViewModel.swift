//
//  QuizViewModel.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 07.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//
import Foundation

final class QuizViewModel {

    enum GenerationState {
        case idle
        case generating
        case readingText
        case success(Quiz)
        case error(String)
    }

    var onStateChange: ((GenerationState) -> Void)?

    private(set) var state: GenerationState = .idle {
        didSet {
            DispatchQueue.main.async {
                self.onStateChange?(self.state)
            }
        }
    }
    private let quizService: QuizService

    init(quizService: QuizService) {
        self.quizService = quizService
    }

    func generateQuiz(from text: String) {
        state = .readingText

        Task {
            do {
                try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
                state = .generating

                let quiz = try await quizService.generateQuiz(for: text)
                state = .success(quiz)
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
}
