//
//  HistoryViewController.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 05.05.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

final class HistoryViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let title = "История тестов"
        static let searchPlaceholder = "Поиск по названию..."
        
        enum Layout {
            static let searchFieldCornerRadius: CGFloat = 12
            static let searchFieldHeight: CGFloat = 48
            static let standardOffset: CGFloat = 16
            static let searchIconSize = CGSize(width: 40, height: 40)
            static let searchIconFrame = CGRect(x: 12, y: 10, width: 20, height: 20)
        }
        
        enum Colors {
            static let gradientStart = UIColor(red: 21/255, green: 93/255, blue: 252/255, alpha: 1)
            static let gradientEnd = UIColor(red: 152/255, green: 16/255, blue: 250/255, alpha: 1)
            static let searchIconTint = UIColor.systemGray
        }
        
        enum Icons {
            static let magnifyingGlass = "magnifyingglass"
        }
    }
    
    // MARK: - Properties
    
    private let viewModel: HistoryViewModel
    
    // MARK: - UI
    
    private lazy var searchField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.placeholder = Constants.searchPlaceholder
        tf.layer.cornerRadius = Constants.Layout.searchFieldCornerRadius
        tf.leftViewMode = .always
        
        let iconView = UIView(frame: CGRect(origin: .zero, size: Constants.Layout.searchIconSize))
        let icon = UIImageView(image: UIImage(systemName: Constants.Icons.magnifyingGlass))
        icon.tintColor = Constants.Colors.searchIconTint
        icon.frame = Constants.Layout.searchIconFrame
        iconView.addSubview(icon)
        
        tf.leftView = iconView
        tf.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        return tf
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.register(HistoryView.self, forCellReuseIdentifier: HistoryView.identifier)
        return table
    }()
    
    private lazy var emptyStateView = HistoryEmptyStateView()
    
    // MARK: - Init
    
    init(viewModel: HistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.title
        setupUI()
        bindViewModel()
        setupActions()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchHistory()
    }
    
    // MARK: - Logic
    
    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            guard let self = self else { return }
            let isEmpty = self.viewModel.filteredResults.isEmpty
            self.emptyStateView.isHidden = !isEmpty
            self.tableView.isHidden = isEmpty
            self.tableView.reloadData()
        }
    }
    
    private func setupActions() {
        emptyStateView.onHomeTapped = { [weak self] in
            self?.tabBarController?.selectedIndex = TabBarPage.home.rawValue
        }
    }
    
    @objc private func searchTextChanged(_ textField: UITextField) {
        let query = textField.text ?? ""
        viewModel.search(query: query)
    }
    
    // MARK: - Layout
    
    private func setupUI() {
        view.applyGradient(
            colors: [Constants.Colors.gradientStart, Constants.Colors.gradientEnd],
            startPoint: CGPoint(x: 0, y: 0),
            endPoint: CGPoint(x: 0, y: 1)
        )
        
        view.addSubviews(searchField, tableView, emptyStateView)
        
        searchField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.Layout.standardOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.Layout.standardOffset)
            make.height.equalTo(Constants.Layout.searchFieldHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchField.snp.bottom).offset(Constants.Layout.standardOffset)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        emptyStateView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryView.identifier, for: indexPath) as! HistoryView
        cell.configure(with: viewModel.filteredResults[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectTest(at: indexPath.row)
    }
}
