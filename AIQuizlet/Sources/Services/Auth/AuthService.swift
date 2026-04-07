//
//  AuthService.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 07.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

final class AuthService {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func login(email: String, password: String) async {
        let request = LoginRequest(email: email, password: password)
            
        do {
            let response: AuthResponse = try await networkManager.request(target: .login(request: request))
            print("Успешный вход, токен: \(response.token)")
        } catch {
            print("Ошибка входа: \(error.localizedDescription)")
        }
        
    }
    
    func register(email: String, password: String) async {
        let request = RegisterRequest(email: email, password: password)
        
        do {
            let response: AuthResponse = try await networkManager.request(target: .register(request: request))
            print("Успешная регистрация, токен: \(response.token)")
        } catch {
            print("Ошибка регистрации: \(error.localizedDescription)")
        }
    }
}
