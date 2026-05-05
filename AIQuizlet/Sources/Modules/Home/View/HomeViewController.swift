//
//  HomeViewController.swift
//  AIQuizlet
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {

    private let viewModel: HomeViewModel
    private var homeView: HomeView { return view as! HomeView }

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = HomeView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        setupActions()
        renderRecentTests()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        updateGradient(for: traitCollection.userInterfaceStyle)

        NotificationCenter.default.addObserver(
            forName: .themeDidChange,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let style = notification.object as? UIUserInterfaceStyle else { return }
            self?.updateGradient(for: style)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if traitCollection.userInterfaceStyle != .dark {
            view.applyGradient(colors: AppColors.backgroundGradient)
        }
    }
}

// MARK: - Actions

private extension HomeViewController {

    @objc func profileTapped() {
        viewModel.profileSelected()
    }
}

// MARK: - Setup Logic

private extension HomeViewController {

    func setupActions() {
        homeView.photoCard.action = { [weak self] in
            self?.viewModel.photoInputSelected()
        }
        homeView.textCard.action = { [weak self] in
            self?.viewModel.textInputSelected()
        }
        homeView.onProfileTap(target: self, action: #selector(profileTapped))
    }

    func renderRecentTests() {
        let tests = viewModel.recentTests
        let isEmpty = tests.isEmpty
        homeView.updateEmptyState(isEmpty: isEmpty)
        if !isEmpty {
            tests.prefix(3).forEach { homeView.addTestResult($0) }
        }
    }

    func updateGradient(for style: UIUserInterfaceStyle) {
        homeView.updateForTheme(style)
        if style == .dark {
            view.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        } else {
            view.applyGradient(colors: AppColors.backgroundGradient)
        }
    }
}
