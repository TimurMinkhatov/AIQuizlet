import UIKit
import SnapKit

final class HomeViewController: UIViewController {

    var viewModel: HomeViewModel!
    
    init(viewModel: HomeViewModel) {
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var homeView: HomeView { return view as! HomeView }
    
    private func setupGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 21/255, green: 93/255, blue: 252/255, alpha: 1).cgColor,
            UIColor(red: 152/255, green: 16/255, blue: 250/255, alpha: 1).cgColor,
            UIColor(red: 130/255, green: 0/255, blue: 219/255, alpha: 1).cgColor
        ]
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    private func renderRecentTests() {
        let tests = viewModel.recentTests
        
        let isEmpty = tests.isEmpty
        homeView.updateEmptyState(isEmpty: isEmpty)
        
        if !isEmpty {
            tests.prefix(3).forEach { test in
                homeView.addTestResult(test)
            }
        }
    }
    
    override func loadView() {
        self.view = HomeView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        extendedLayoutIncludesOpaqueBars = true
        setupActions()
        renderRecentTests()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if view.layer.sublayers?.first( where: { $0 is CAGradientLayer }) == nil {
            setupGradient()
        }
        
    }

    private func setupActions() {
        homeView.photoCard.action = { [weak self] in
            print("Нажал на фото")
        
        }
        homeView.textCard.action = { [weak self] in
            print("Нажал на текст")
        }
        
        homeView.onProfileTap(target: self, action: #selector(profileTapped))
    }
    
    @objc private func profileTapped() {
        print("Переходим в профиль")
        viewModel.profileSelected()
    }
    
}
