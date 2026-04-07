//
//  API.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 07.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//
import Foundation
import Moya

enum API {
    case login(request: LoginRequest)
    case register(request: RegisterRequest)
    case getQuizzes
    case generateQuiz(prompt: String)
}

extension API: Moya.TargetType {
    var baseURL: URL {
        switch self {
        case .generateQuiz:
            return URL(string: "https://openrouter.ai/api/v1")!
        default:
            return URL(string: "https://openrouter.ai/api/v1")!
        }
    }
    
    var path: String {
        switch self {
        case .login: return "auth/login"
            
        case .register: return "auth/register"
        
        case .getQuizzes: return "quizzes"
            
        case .generateQuiz: return "/chat/completions"
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getQuizzes: return .get
        case .generateQuiz: return .post
        default : return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
            
        case .login(let request):
            return .requestJSONEncodable(request)
            
        case .register(let request):
            return .requestJSONEncodable(request)
        
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
    
    var headers: [String : String]? {
        var headers = ["Content-Type": "application/json"]
        
        if case.generateQuiz(let prompt) = self {
            headers["Authorization"] = "Bearer my_key"
            headers["HTTP-Referer"] = "https://github.com/TimurMinkhatov/AIQuizlet"
        }
        return headers
    }
}
