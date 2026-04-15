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
    
    var viewModel: HomeViewModel!
    private var homeView: HomeView { return view as! HomeView }
    private let gradient = CAGradientLayer()
    
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
        renderRecentTests()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if view.layer.sublayers?.first(where: { $0 is CAGradientLayer }) == nil {
            setupGradient()
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
            // Здесь будет логика для фото
        }
        homeView.textCard.action = { [weak self] in
            self?.viewModel.textInputSelected()
        }
        homeView.onProfileTap(target: self, action: #selector(profileTapped))
    }
    
    func setupGradient() {
        gradient.colors = [
            UIColor(red: 21/255, green: 93/255, blue: 252/255, alpha: 1).cgColor,
            UIColor(red: 152/255, green: 16/255, blue: 250/255, alpha: 1).cgColor,
            UIColor(red: 130/255, green: 0/255, blue: 219/255, alpha: 1).cgColor
        ]
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func renderRecentTests() {
        let tests = viewModel.recentTests
        let isEmpty = tests.isEmpty
        homeView.updateEmptyState(isEmpty: isEmpty)
        
        if !isEmpty {
            tests.prefix(3).forEach { test in
                homeView.addTestResult(test)
            }
        }
    }
}