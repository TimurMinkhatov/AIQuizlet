//
//  QuizAPI.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 09.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Moya
import Foundation

enum QuizAPI {
    case getQuizzes
    case generateQuiz(prompt: String)
}

extension QuizAPI: Moya.TargetType {

    var baseURL: URL {
        return URL(string: "https://openrouter.ai/api/v1")!
    }

    var path: String {
        switch self {
        case .getQuizzes: return "quizzes"

        case .generateQuiz: return "/chat/completions"

        }
    }

    var method: Moya.Method {
        switch self {
        case .getQuizzes: return .get
        case .generateQuiz: return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case .getQuizzes:
            return .requestPlain

        case .generateQuiz(let prompt):
            let params: [String: Any] = [
                "model": "openai/gpt-oss-120b:free",
                "messages": [["role": "user", "content": prompt]]
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)

        }
    }
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer api_key"
        ]
    }
}
