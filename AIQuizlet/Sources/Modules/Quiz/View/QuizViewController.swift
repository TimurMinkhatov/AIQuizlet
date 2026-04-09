//
//  QuizViewController.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 07.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

class QuizViewController: UIViewController {
    private let viewModel: QuizViewModel

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        return label
    }()

    private let loader: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .systemBlue
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

        statusLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }

        loader.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(50)
        }
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
