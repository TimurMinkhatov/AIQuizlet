//
//  AuthService.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 07.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//
enum AuthError: Error {
    case loginFailed
    case registerFailed
    case unknown(String)

    var localizedDescription: String {
        switch self {
            case .loginFailed: return "Неверный логин или пароль"
        case .registerFailed: return "Ошибка регистрации"
        case .unknown(let message): return message
        }
    }
}

final class AuthService: AuthServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func login(email: String, password: String) async throws -> AuthResponse {
        let request = LoginRequest(email: email, password: password)

        do {
            let response: AuthResponse = try await networkManager.request(target: AuthAPI.login(request: request))
            print("Успешный вход, токен: \(response.token)")
            return response

        } catch {
            print("Ошибка входа: \(error.localizedDescription)")
            throw AuthError.loginFailed

        }

    }

    func register(email: String, password: String) async throws -> AuthResponse {
        let request = RegisterRequest(email: email, password: password)

        do {
            let response: AuthResponse = try await networkManager.request(target: AuthAPI.register(request: request))
            print("Успешная регистрация, токен: \(response.token)")
            return response
        } catch {
            print("Ошибка регистрации: \(error.localizedDescription)")
            throw AuthError.registerFailed

        }
    }
}
