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
    
    enum Strings {
        static let cellIdentifier = "AnalysisCell"
        static let headerTitle = "Разбор вопросов"
        static let fatalErrorInit = "init(coder:) has not been implemented"
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
        fatalError(Constants.Strings.fatalErrorInit)
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.drawCircularProgress(percentage: viewModel.viewState.percentage)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension QuizResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.viewState.questionsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Strings.cellIdentifier, for: indexPath) as? QuestionAnalysisCell else {
            return UITableViewCell()
        }
        
        let question = viewModel.getQuestion(at: indexPath.row)
        let userAnswerIndex = viewModel.getUserAnswer(at: indexPath.row)
        let isExpanded = viewModel.expandedIndexSet.contains(indexPath.row)
        
        cell.contentView.backgroundColor = .white
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
        return createSectionHeader(title: Constants.Strings.headerTitle)
    }
}

// MARK: - Private Methods

private extension QuizResultViewController {
    
    func createSectionHeader(title: String) -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.layer.cornerRadius = Constants.Layout.headerCornerRadius
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: Constants.Layout.titleFontSize, weight: .bold)
        titleLabel.textColor = .black
        
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.Layout.titleTopOffset)
            $0.leading.equalToSuperview().offset(Constants.Layout.titleLeadingOffset)
            $0.bottom.equalToSuperview().offset(Constants.Layout.titleBottomOffset)
        }
        
        return headerView
    }
    
    func setupNavigation() {
        navigationItem.hidesBackButton = true
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
