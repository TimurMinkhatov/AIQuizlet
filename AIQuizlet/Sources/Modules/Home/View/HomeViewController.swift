//
//  HomeViewController.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 07.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: HomeViewModel
    private var homeView: HomeView { return view as! HomeView }
    
    // MARK: - Init
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        self.view = HomeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        setupActions()
        bindViewModel()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchRecentTests()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.applyGradient(
            colors: [
                UIColor(red: 21/255, green: 93/255, blue: 252/255, alpha: 1),
                UIColor(red: 152/255, green: 16/255, blue: 250/255, alpha: 1),
                UIColor(red: 130/255, green: 0/255, blue: 219/255, alpha: 1)
            ],
            startPoint: CGPoint(x: 0.5, y: 0),
            endPoint: CGPoint(x: 0.5, y: 1)
        )
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
