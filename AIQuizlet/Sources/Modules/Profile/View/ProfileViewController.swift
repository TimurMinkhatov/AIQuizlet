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

    private lazy var profileView = ProfileView()

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
        title: "Пройдено вопросов",
        systemImage: "checkmark.circle",
        tintColor: .systemPurple
    )

    private lazy var statsTopRow: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [totalTestsCard, avgScoreCard])
        stack.axis = .horizontal
        stack.spacing = Constants.statsSpacing
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var statsBottomRow: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [bestScoreCard, completedCard])
        stack.axis = .horizontal
        stack.spacing = Constants.statsSpacing
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var statsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [statsTopRow, statsBottomRow])
        stack.axis = .vertical
        stack.spacing = Constants.statsSpacing
        return stack
    }()

    private lazy var themeSelectorView = ThemeSelectorView()
    private lazy var languageSelectorView = LanguageSelectorView()

    private lazy var actionsCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = Constants.actionsCornerRadius
        return view
    }()

    private lazy var clearDataButton = makeSettingsButton(
        image: "trash",
        color: .systemRed,
        text: "Очистить данные"
    )

    private lazy var logoutButton = makeSettingsButton(
        image: "rectangle.portrait.and.arrow.right",
        color: .label,
        text: "Выйти"
    )

    private lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.text = "Версия 1.0.0"
        label.font = .systemFont(ofSize: Constants.versionFontSize)
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
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Lifecycle

extension ProfileViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Профиль"
        setupLayout()
        setupActions()
        bindViewModel()
        profileView.configure(with: viewModel)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
}

// MARK: - Private Methods

private extension ProfileViewController {

    func setupLayout() {
        view.layer.insertSublayer(gradientLayer, at: 0)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(profileView)
        contentView.addSubview(statsStack)
        contentView.addSubview(themeSelectorView)
        contentView.addSubview(languageSelectorView)
        contentView.addSubview(actionsCardView)
        contentView.addSubview(versionLabel)
        actionsCardView.addSubview(clearDataButton)
        actionsCardView.addSubview(logoutButton)

        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview()
        }

        profileView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.sectionSpacing)
            $0.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
        }

        statsStack.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(Constants.sectionSpacing)
            $0.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
        }

        statsTopRow.snp.makeConstraints {
            $0.height.equalTo(Constants.statsCardHeight)
        }

        statsBottomRow.snp.makeConstraints {
            $0.height.equalTo(Constants.statsCardHeight)
        }

        themeSelectorView.snp.makeConstraints {
            $0.top.equalTo(statsStack.snp.bottom).offset(Constants.sectionSpacing)
            $0.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
        }

        languageSelectorView.snp.makeConstraints {
            $0.top.equalTo(themeSelectorView.snp.bottom).offset(Constants.sectionSpacing)
            $0.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
        }

        actionsCardView.snp.makeConstraints {
            $0.top.equalTo(languageSelectorView.snp.bottom).offset(Constants.sectionSpacing)
            $0.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
        }

        clearDataButton.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
            $0.height.equalTo(Constants.buttonHeight)
        }

        logoutButton.snp.makeConstraints {
            $0.top.equalTo(clearDataButton.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview().inset(Constants.horizontalInset)
            $0.height.equalTo(Constants.buttonHeight)
        }

        versionLabel.snp.makeConstraints {
            $0.top.equalTo(actionsCardView.snp.bottom).offset(Constants.sectionSpacing)
            $0.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
            $0.bottom.equalToSuperview().inset(Constants.versionBottomInset)
        }
    }

    func setupActions() {
        clearDataButton.addTarget(self, action: #selector(clearDataTapped), for: UIControl.Event.touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: UIControl.Event.touchUpInside)

        themeSelectorView.onThemeSelected = { [weak self] style in
            self?.view.window?.overrideUserInterfaceStyle = style
        }

        languageSelectorView.onLanguageSelected = { _ in }
    }

    func bindViewModel() {
        viewModel.onError = { [weak self] error in
            guard let self else { return }
            let alert = UIAlertController(
                title: "Ошибка",
                message: error,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "ОК", style: .default))
            present(alert, animated: true)
        }
    }

    func updateUI() {
        Task {
            if let stats = try? await viewModel.fetchStats() {
                totalTestsCard.setValue("\(stats.totalQuizzes)")
                avgScoreCard.setValue("\(Int(stats.avgScore))%")
                bestScoreCard.setValue("\(Int(stats.bestScores))%")
                completedCard.setValue("\(stats.totalQuestions)")
            }
        }
    }

    func makeSettingsButton(image: String, color: UIColor, text: String) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.title = text
        config.image = UIImage(systemName: image)
        config.imagePadding = Constants.buttonImagePadding
        config.baseForegroundColor = color
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .left
        return button
    }

    @objc func clearDataTapped() {
        let alert = UIAlertController(
            title: "Очистка данных",
            message: "Вы уверены, что хотите удалить все тесты?",
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
            title: "Выход",
            message: "Вы действительно хотите выйти из аккаунта?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Выход", style: .destructive) { [weak self] _ in
            self?.viewModel.logout()
        })
        present(alert, animated: true)
    }
}

// MARK: - Constants

private extension ProfileViewController {
    enum Constants {
        static let statsSpacing: CGFloat = 12
        static let statsCardHeight: CGFloat = 100
        static let sectionSpacing: CGFloat = 12
        static let horizontalInset: CGFloat = 16
        static let buttonHeight: CGFloat = 44
        static let buttonImagePadding: CGFloat = 8
        static let actionsCornerRadius: CGFloat = 16
        static let versionFontSize: CGFloat = 13
        static let versionBottomInset: CGFloat = 24
    }
}
