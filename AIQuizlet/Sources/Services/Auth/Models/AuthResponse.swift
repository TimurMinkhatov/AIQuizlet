//
//  AuthResponse.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 07.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

struct AuthResponse: Decodable {
    let token: String
    let userId: String
}
