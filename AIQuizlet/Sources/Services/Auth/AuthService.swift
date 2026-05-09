//
//  AuthService.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 03/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import FirebaseAuth

final class AuthService {
    
    // MARK: - Properties
    
    static let shared = AuthService()
    var currentUser: FirebaseAuth.User? {
        Auth.auth().currentUser
    }
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Public Methods
    
   
    @MainActor
    func requireUserId(timeoutSeconds: TimeInterval = 5) async throws -> String {
        if let uid = Auth.auth().currentUser?.uid, !uid.isEmpty {
            return uid
        }
        
        let deadline = Date().addingTimeInterval(timeoutSeconds)
        
        while Date() < deadline {
            if let uid = Auth.auth().currentUser?.uid, !uid.isEmpty {
                return uid
            }
            
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                var handled = false
                let handle = Auth.auth().addStateDidChangeListener { _, _ in
                    guard !handled else { return }
                    handled = true
                    continuation.resume()
                }
                
                Task {
                    try? await Task.sleep(nanoseconds: 250_000_000)
                    guard !handled else { return }
                    handled = true
                    Auth.auth().removeStateDidChangeListener(handle)
                    continuation.resume()
                }
            }
        }
        
        if let uid = Auth.auth().currentUser?.uid, !uid.isEmpty {
            return uid
        }
        
        throw NSError(domain: "AuthService", code: 401, userInfo: [
            NSLocalizedDescriptionKey: "User is not authenticated"
        ])
    }
    
    func register(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authData ,error in
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
        } catch _ as NSError {
        }
    }
}
