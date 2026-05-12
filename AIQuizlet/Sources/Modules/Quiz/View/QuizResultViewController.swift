//
//  QuizResultViewController.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 01.05.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - Constants

private enum Constants {
    enum Layout {
        static let headerCornerRadius: CGFloat = 32
        static let titleFontSize: CGFloat = 20
        static let titleTopOffset: CGFloat = 24
        static let titleLeadingOffset: CGFloat = 24
        static let titleBottomOffset: CGFloat = -16
    }
}

final class QuizResultViewController: UIViewController {
    
    // MARK: - Properties
    
    private let contentView = QuizResultView()
    private let viewModel: QuizResultViewModel
    
    // MARK: - Init
    
    init(viewModel: QuizResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        bindViewModel()
        setupNavigation()
        setupTargets()
        
        let style = ThemeManager.shared.savedStyle == .unspecified
            ? traitCollection.userInterfaceStyle
            : ThemeManager.shared.savedStyle
        let backgroundColor = (style == .dark) ? AppColors.historyCard : .white
        contentView.tableView.backgroundColor = backgroundColor
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(!viewModel.isFromHistory, animated: true)
        contentView.drawCircularProgress(percentage: viewModel.viewState.percentage)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension QuizResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.viewState.questionsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnalysisCell", for: indexPath) as? QuestionAnalysisCell else {
            return UITableViewCell()
        }
        
        let question = viewModel.getQuestion(at: indexPath.row)
        let userAnswerIndex = viewModel.getUserAnswer(at: indexPath.row)
        let isExpanded = viewModel.expandedIndexSet.contains(indexPath.row)
        
        let style = ThemeManager.shared.savedStyle == .unspecified
            ? traitCollection.userInterfaceStyle
            : ThemeManager.shared.savedStyle
            
        cell.contentView.backgroundColor = (style == .dark) ? AppColors.historyCard : .white
        
        cell.configure(with: question, userAnswerIndex: userAnswerIndex, index: indexPath.row, isExpanded: isExpanded)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.expandedIndexSet.contains(indexPath.row) {
            viewModel.expandedIndexSet.remove(indexPath.row)
        } else {
            viewModel.expandedIndexSet.insert(indexPath.row)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createSectionHeader(title: L10n.Result.Breakdown.title)
    }
}

// MARK: - Private Methods

private extension QuizResultViewController {
    
    func createSectionHeader(title: String) -> UIView {
        let headerView = UIView()
        
        let style = ThemeManager.shared.savedStyle == .unspecified
            ? traitCollection.userInterfaceStyle
            : ThemeManager.shared.savedStyle
            
        headerView.backgroundColor = (style == .dark) ? AppColors.historyCard : .white
        
        headerView.layer.cornerRadius = Constants.Layout.headerCornerRadius
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: Constants.Layout.titleFontSize, weight: .bold)
        titleLabel.textColor = .label
        
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.Layout.titleTopOffset)
            $0.leading.equalToSuperview().offset(Constants.Layout.titleLeadingOffset)
            $0.bottom.equalToSuperview().offset(Constants.Layout.titleBottomOffset)
        }
        
        return headerView
    }
    
    func setupNavigation() {
        navigationItem.hidesBackButton = !viewModel.isFromHistory
        if let viewControllers = navigationController?.viewControllers, viewControllers.count > 1 {
            let previousVC = viewControllers[viewControllers.count - 2]
            previousVC.navigationItem.backButtonDisplayMode = .minimal
        }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
    }
    
    func setupTargets() {
        contentView.retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        contentView.homeButton.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
    }
    
    func setupDelegates() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
    }
    
    func bindViewModel() {
        let viewState = viewModel.viewState
        contentView.configure(with: viewState)
    }
    
    // MARK: - Actions
    
    @objc func retryTapped() {
        viewModel.retryQuiz()
    }
    
    @objc func homeTapped() {
        viewModel.goHome()
    }
}
