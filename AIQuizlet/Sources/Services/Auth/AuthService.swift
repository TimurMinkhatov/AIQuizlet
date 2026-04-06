//
//  AuthService.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 03/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import FirebaseAuth

final class AuthService {
    
    static let shared = AuthService()
    
    private init() {}
    
    func register(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Ошибка выхода из аккаунта: %@", (signOutError))
        }
    }
}
