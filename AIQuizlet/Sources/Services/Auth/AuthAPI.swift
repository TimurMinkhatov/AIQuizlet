//
//  AuthAPI.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 09.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Moya
import Foundation

// MARK: - AuthAPI

enum AuthAPI {
    case login(request: LoginRequest)
    case register(request: RegisterRequest)
}

// MARK: - TargetType Implementation

extension AuthAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://aiquizlet.com")!
    }

    var path: String {
        switch self {
        case .login: return "auth/login"
        case .register: return "auth/register"
        }
    }

    var method: Moya.Method {
        .post
    }

    var task: Task {
        switch self {
        case .login(let request):
            return .requestJSONEncodable(request)
        case .register(let request):
            return .requestJSONEncodable(request)
        }
    }

    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
}
