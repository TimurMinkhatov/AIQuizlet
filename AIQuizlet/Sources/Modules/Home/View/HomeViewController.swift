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
        bindViewModel()
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchRecentTests()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if traitCollection.userInterfaceStyle != .dark {
            view.applyGradient(colors: AppColors.backgroundGradient)
        }
    }
}

// MARK: - Private Methods

private extension HomeViewController {

    func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            self?.renderRecentTests()
        }
    }

    func setupActions() {
        homeView.photoCard.action = { [weak self] in
            self?.viewModel.photoInputSelected()
        }
        homeView.textCard.action = { [weak self] in
            self?.viewModel.textInputSelected()
        }
        homeView.onProfileTap(target: self, action: #selector(profileTapped))
        homeView.onSeeAllTap(target: self, action: #selector(seeAllTestsTapped))
    }

    func renderRecentTests() {
        homeView.clearRecentTests()

        let tests = viewModel.recentTests
        let isEmpty = tests.isEmpty

        homeView.updateEmptyState(isEmpty: isEmpty)
        if !isEmpty {
            tests.enumerated().forEach { index, test in
                let card = RecentTestCardView(test: test)
                card.onTap = { [weak self] in
                    self?.viewModel.didSelectRecentTest(at: index)
                }
                homeView.addTestResult(card)
            }
        }
    }

    func updateGradient(for style: UIUserInterfaceStyle) {
        homeView.updateForTheme(style)
        if style == .dark {
            view.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
            view.backgroundColor = AppColors.background
        } else {
            view.applyGradient(colors: AppColors.backgroundGradient)
        }
    }
}

// MARK: - Actions

extension HomeViewController {
    @objc func seeAllTestsTapped() {
        viewModel.seeAllRecentTestsSelected()
    }

    @objc func profileTapped() {
        viewModel.profileSelected()
    }
}
