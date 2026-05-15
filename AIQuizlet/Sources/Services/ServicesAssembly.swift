//
//  ServicesAssembly.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 01/05/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import SwiftData

final class ServicesAssembly {

    // MARK: - Properties

    let storageService: StorageServiceProtocol
    let authService: AuthServiceProtocol
    let quizService: QuizServiceProtocol
    let cameraService: CameraServiceProtocol
    let firestoreService: FirestoreServiceProtocol

    // MARK: - Init

    init(modelContainer: ModelContainer) {
        self.storageService = StorageService(modelContainer: modelContainer)
        self.authService = AuthService()
        self.quizService = QuizService(networkManager: NetworkManager())
        self.cameraService = CameraService()
        self.firestoreService = FirestoreService()
    }
}
