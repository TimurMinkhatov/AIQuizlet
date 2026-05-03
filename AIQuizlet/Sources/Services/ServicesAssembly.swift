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

    let storageService: StorageService
    let authService: AuthService
    let quizService: QuizService
    let cameraService: CameraService
//    let firestoreService: FirestoreService


    // MARK: - Init

    init(modelContainer: ModelContainer) {
        self.storageService = StorageService(modelContainer: modelContainer)
        self.authService = AuthService.shared
        self.quizService = QuizService(networkManager: NetworkManager())
        self.cameraService = CameraService()
//        self.firestoreService = FirestoreService()

    }
}
