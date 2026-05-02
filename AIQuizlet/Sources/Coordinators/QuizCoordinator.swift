import UIKit

final class QuizCoordinator: Coordinator {

    // MARK: - Properties

    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    let assembly: ServicesAssembly

    // MARK: - Init

    init(navigationController: UINavigationController, assembly: ServicesAssembly) {
        self.navigationController = navigationController
        self.assembly = assembly
    }

    // MARK: - Coordinator

    func start() {
        showTextInput()
    }

    // MARK: - Public Methods

    func didGenerateQuiz(_ quiz: Quiz) {
        showQuiz(quiz: quiz)
    }
}

// MARK: - Private Methods

private extension QuizCoordinator {

    func showTextInput() {
        let quizService = QuizService(networkManager: NetworkManager())
        let vm = TextInputViewModel(quizService: quizService)
        vm.coordinator = self
        let vc = TextInputViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }

    func showQuiz(quiz: Quiz) {
        let quizService = QuizService(networkManager: NetworkManager())
        let vm = QuizViewModel(assembly: assembly)
        vm.setQuiz(quiz)
        let vc = QuizViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
}
