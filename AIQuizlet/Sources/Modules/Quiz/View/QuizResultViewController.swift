//
//  QuizResultViewController.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 01.05.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit

final class QuizResultViewController: UIViewController {
    
    private let contentView = QuizResultView()
    private let viewModel: QuizResultViewModel
    
    init(viewModel: QuizResultViewModel) {
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.drawCircularProgress(percentage: viewModel.percentageValue)
    }
    
    private func setupDelegates() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
    }
    
    private func bindViewModel() {
        contentView.configure(
            with: viewModel.scoreText,
            description: viewModel.resultDescription
        )
    }
}

// MARK: - TableView DataSource & Delegate

extension QuizResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfQuestions
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnalysisCell", for: indexPath) as? QuestionAnalysisCell else {
            return UITableViewCell()
        }
        
        let question = viewModel.getQuestion(at: indexPath.row)
        let isExpanded = viewModel.expandedIndexSet.contains(indexPath.row)
        
        cell.configure(with: question, isExpanded: isExpanded)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.expandedIndexSet.contains(indexPath.row) {
            viewModel.expandedIndexSet.remove(indexPath.row)
        } else {
            viewModel.expandedIndexSet.insert(indexPath.row)
        }
        
        tableView.performBatchUpdates(nil)
        
        if let cell = tableView.cellForRow(at: indexPath) as? QuestionAnalysisCell {
            let question = viewModel.getQuestion(at: indexPath.row)
            cell.configure(with: question, isExpanded: viewModel.expandedIndexSet.contains(indexPath.row))
        }
    }
}
