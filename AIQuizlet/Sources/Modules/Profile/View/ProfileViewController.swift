//
//  ProfileViewController.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 24/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

final class ProfileViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: ProfileViewModel

    // MARK: - UI Components

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private lazy var contentView = UIView()

    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(red: 43/255, green: 127/255, blue: 255/255, alpha: 1).cgColor,
            UIColor(red: 152/255, green: 16/255, blue: 250/255, alpha: 1).cgColor
        ]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        return layer
    }()

    private lazy var avatarGradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(red: 43/255, green: 127/255, blue: 255/255, alpha: 1).cgColor,
            UIColor(red: 152/255, green: 16/255, blue: 250/255, alpha: 1).cgColor
        ]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        return layer
    }()

    private lazy var profileCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 20
        return view
    }()

    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .white
        return imageView
    }()

    private lazy var profileContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 40
        view.clipsToBounds = true
        return view
    }()

    private lazy var infoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Профиль"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var totalTestsCard = StatCardView(
        title: "Всего тестов",
        systemImage: "book",
        tintColor: .systemBlue
    )

    private lazy var avgScoreCard = StatCardView(
        title: "Средний балл",
        systemImage: "chart.line.uptrend.xyaxis",
        tintColor: .systemGreen
    )

    private lazy var bestScoreCard = StatCardView(
        title: "Лучший результат",
        systemImage: "trophy",
        tintColor: .systemYellow
    )

    private lazy var completedCard = StatCardView(
        title: "Вопросов решено",
        systemImage: "checkmark.circle",
        tintColor: .systemPurple
    )

    private lazy var statsTopRow: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var statsBottomRow: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var statsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()

    private lazy var themeSelectorView = ThemeSelectorView()
    private lazy var languageSelectorView = LanguageSelectorView()

    private lazy var actionsCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 16
        return view
    }()

    private lazy var clearDataButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Очистить все данные"
        config.image = UIImage(systemName: "trash")
        config.baseForegroundColor = .systemRed
        config.imagePadding = 8
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .left
        return button
    }()

    private lazy var logoutButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Выйти из аккаунта"
        config.image = UIImage(systemName: "rectangle.portrait.and.arrow.right")
        config.baseForegroundColor = .label
        config.imagePadding = 8
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .left
        return button
    }()

    private lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.text = "Версия 1.0.0"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    // MARK: - Init

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has не been implemented")
    }
}

// MARK: - Lifecycle

extension ProfileViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Профиль"
        setupNavigationBar()
        setupLayout()
        setupActions()
        bindViewModel()
        updateUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
        avatarGradientLayer.frame = profileContainerView.bounds
        avatarGradientLayer.cornerRadius = profileContainerView.layer.cornerRadius
    }
}

// MARK: - Private Methods

private extension ProfileViewController {

    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }

    func setupLayout() {
        view.layer.insertSublayer(gradientLayer, at: 0)
        profileContainerView.layer.insertSublayer(avatarGradientLayer, at: 0)

        statsTopRow.addArrangedSubview(totalTestsCard)
        statsTopRow.addArrangedSubview(avgScoreCard)
        statsBottomRow.addArrangedSubview(bestScoreCard)
        statsBottomRow.addArrangedSubview(completedCard)
        statsStack.addArrangedSubview(statsTopRow)
        statsStack.addArrangedSubview(statsBottomRow)

        actionsCardView.addSubview(clearDataButton)
        actionsCardView.addSubview(logoutButton)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(profileCardView)
        profileCardView.addSubview(profileContainerView)
        profileContainerView.addSubview(profileImageView)
        profileCardView.addSubview(infoStack)
        infoStack.addArrangedSubview(nameLabel)
        infoStack.addArrangedSubview(emailLabel)
        contentView.addSubview(statsStack)
        contentView.addSubview(themeSelectorView)
        contentView.addSubview(languageSelectorView)
        contentView.addSubview(actionsCardView)
        contentView.addSubview(versionLabel)

        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview()
        }

        profileCardView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        profileContainerView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.bottom.equalToSuperview().inset(24)
            $0.width.height.equalTo(80)
        }

        profileImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(30)
        }

        infoStack.snp.makeConstraints {
            $0.leading.equalTo(profileContainerView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(profileContainerView)
        }

        statsStack.snp.makeConstraints {
            $0.top.equalTo(profileCardView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        statsTopRow.snp.makeConstraints {
            $0.height.equalTo(100)
        }

        statsBottomRow.snp.makeConstraints {
            $0.height.equalTo(100)
        }

        themeSelectorView.snp.makeConstraints {
            $0.top.equalTo(statsStack.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        languageSelectorView.snp.makeConstraints {
            $0.top.equalTo(themeSelectorView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        actionsCardView.snp.makeConstraints {
            $0.top.equalTo(languageSelectorView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        clearDataButton.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }

        logoutButton.snp.makeConstraints {
            $0.top.equalTo(clearDataButton.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }

        versionLabel.snp.makeConstraints {
            $0.top.equalTo(actionsCardView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(24)
        }
    }

    func setupActions() {
        clearDataButton.addTarget(self, action: #selector(clearDataTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)

        themeSelectorView.onThemeSelected = { [weak self] style in
            self?.view.window?.overrideUserInterfaceStyle = style
        }

        languageSelectorView.onLanguageSelected = { _ in }
    }

    func bindViewModel() {
        viewModel.onError = { [weak self] error in
            guard let self else { return }
            let alert = UIAlertController(title: "Ошибка", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

    func updateUI() {
        emailLabel.text = viewModel.email
        if let stats = try? viewModel.fetchStats() {
            totalTestsCard.setValue("\(stats.totalQuizzes)")
            avgScoreCard.setValue("\(Int(stats.avgScore))%")
            bestScoreCard.setValue("\(Int(stats.bestScores))%")
            completedCard.setValue("\(stats.totalQuestions)")
        }
    }

    @objc func clearDataTapped() {
        let alert = UIAlertController(
            title: "Удалить все данные?",
            message: "Это действие удалит все созданные тесты и результаты. Восстановить данные будет невозможно.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.viewModel.clearData()
        })
        present(alert, animated: true)
    }

    @objc func logoutTapped() {
        let alert = UIAlertController(
            title: "Вы уверены, что хотите выйти?",
            message: "Вы сможете войти снова в любое время.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Выйти из аккаунта", style: .destructive) { [weak self] _ in
            self?.viewModel.logout()
        })
        present(alert, animated: true)
    }
}
