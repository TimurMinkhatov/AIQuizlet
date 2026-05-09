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
        let servicesAssembly = ServicesAssembly(modelContainer: container)

        window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        appCoordinator = AppCoordinator(
            navigationController: navigationController,
            window: window,
            servicesAssembly: servicesAssembly
        )
        appCoordinator?.start()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        NotificationCenter.default.addObserver(
            forName: .languageDidChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.restartApp()
        }
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

    func restartApp() {
        guard let window else { return }
        let container = createModelContainer()
        let assembly = ServicesAssembly(modelContainer: container)
        let navigationController = UINavigationController()
        appCoordinator = AppCoordinator(
            navigationController: navigationController,
            window: window,
            servicesAssembly: assembly
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
                self.appCoordinator?.start()
            }
        }
    }
}
