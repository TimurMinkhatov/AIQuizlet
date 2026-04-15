//
//  LoginRequest.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 07.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation

// MARK: - LoginRequest

struct LoginRequest: Codable {
    let email: String
    let password: String
}
