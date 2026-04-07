//
//  QuizResponse.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 07.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

struct QuizResponse: Decodable {
    let choices: [QuizChoice]
}

struct QuizChoice: Decodable {
    let message: Message
}

struct Message: Decodable {
    let content: String
}

struct Quiz: Decodable {
    let title: String
    let questions: [Question]
}

struct Question: Decodable {
    let text: String
    let answers: [String]
    let correctAnswer: Int
}
