//
//  SceneDelegate.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 23/03/2026.
//

import UIKit
import SwiftData

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    // MARK: - UIWindowSceneDelegate

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let container = createModelContainer()

        window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        appCoordinator = AppCoordinator(
            navigationController: navigationController,
            window: window,
            modelContainer: container
        )
        appCoordinator?.start()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

// MARK: - Private Methods

private extension SceneDelegate {

    func createModelContainer() -> ModelContainer {
        let schema = Schema([
            QuizRecord.self,
            QuestionRecord.self,
            QuizResult.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
}
