//
//  AuthViewModel.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 07/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation

enum AuthState {
    case login
    case register
}

class AuthViewModel {
    weak var coordinator: AuthCoordinator?
    private let authService = AuthService.shared
    
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var onError: ((String) -> Void)?
    
    func signIn() {
        guard validateLoginForm() else { return }
        authService.signIn(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.coordinator?.didFinishAuth()
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
    
    func register() {
        guard validateRegisterForm() else { return }
        authService.register(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.coordinator?.didFinishAuth()
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
    
    private func validateLoginForm() -> Bool {
        let emailValid = !email.isEmpty && email.contains("@") && email.contains(".")
        let passwordValid = !password.isEmpty
        if !emailValid { onError?("Введите корректный email"); return false }
        if !passwordValid { onError?("Введите пароль"); return false }
        return true
    }
    
    private func validateRegisterForm() -> Bool {
        let emailValid = !email.isEmpty && email.contains("@") && email.contains(".")
        let passwordValid = !password.isEmpty && password.count >= 6
        if !emailValid { onError?("Введите корректный email"); return false }
        if !passwordValid { onError?("Пароль должен быть не менее 6 символов"); return false }
        if password != confirmPassword { onError?("Пароли не совпадают"); return false }
        return true
    }
}
