//
//  QuizResultViewController.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 01.05.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit

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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.drawCircularProgress(percentage: viewModel.percentageValue)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension QuizResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfQuestions
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnalysisCell", for: indexPath) as? QuestionAnalysisCell else {
            return UITableViewCell()
        }
        
        let question = viewModel.getQuestion(at: indexPath.row)
        let isExpanded = viewModel.expandedIndexSet.contains(indexPath.row)
        
        cell.contentView.backgroundColor = .white
        
        cell.configure(with: question, index: indexPath.row, isExpanded: isExpanded)
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
    
    // MARK: - Section Header Configuration
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.layer.cornerRadius = 32
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let titleLabel = UILabel()
        titleLabel.text = "Разбор вопросов"
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .black
        
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        return headerView
    }
}

// MARK: - Private Methods

private extension QuizResultViewController {
    
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
        contentView.configure(
            percentageText: viewModel.scoreText,
            statusText: viewModel.statusText,
            description: viewModel.resultDescription,
            percentage: viewModel.percentageValue
        )
    }
    
    // MARK: - Actions
    
    @objc func retryTapped() {
        viewModel.retryQuiz()
    }
    
    @objc func homeTapped() {
        viewModel.goHome()
    }
}
