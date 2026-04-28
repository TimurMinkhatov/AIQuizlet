//
//  AuthServiceProtocol.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 09.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

// MARK: - AuthServiceProtocol

protocol AuthServiceProtocol {
    func login(email: String, password: String)
    func register(email: String, password: String)
}
