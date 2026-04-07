//
//  QuizViewController.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 07.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    private let viewModel: QuizViewModel
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loader: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    init(viewModel: QuizViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(statusLabel)
        view.addSubview(loader)
        statusLabel.textColor = .label
        loader.color = .systemBlue
        
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            loader.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20),
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loader.widthAnchor.constraint(equalToConstant: 50),
            loader.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .idle:
                self.loader.stopAnimating()
            case .readingText:
                self.statusLabel.text = "Изучаю текст..."
                self.loader.startAnimating()
            case .generating:
                self.statusLabel.text = "Придумываю вопросы..."
                self.loader.startAnimating()
            case .success(let quiz):
                self.loader.stopAnimating()
                self.statusLabel.text = "Тест '\(quiz.title)' готов!"
            case .error(let message):
                self.loader.stopAnimating()
                self.statusLabel.text = "Ошибка: \(message)"
                self.statusLabel.textColor = .systemRed
            }
        }
    }
}
