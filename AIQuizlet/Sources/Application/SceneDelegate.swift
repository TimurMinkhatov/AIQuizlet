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

        let splashVC = SplashViewController()
        let navigationController = UINavigationController(rootViewController: splashVC)
        navigationController.navigationBar.isHidden = true
        navigationController.view.backgroundColor = UIColor(red: 21/255, green: 93/255, blue: 252/255, alpha: 1)

        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = UIColor(red: 21/255, green: 93/255, blue: 252/255, alpha: 1)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        appCoordinator = AppCoordinator(
            navigationController: navigationController,
            window: window,
            servicesAssembly: servicesAssembly
        )
        appCoordinator?.start()

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
                window.rootViewController = navigationController
                self.appCoordinator?.restartWithoutSplash()
            }
        }
    }
}
