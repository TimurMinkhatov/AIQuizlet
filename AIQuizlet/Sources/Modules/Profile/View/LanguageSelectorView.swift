//
//  LanguageSelectorView.swift
//  AIQuizlet
//

import UIKit
import SnapKit

final class LanguageSelectorView: UIView {

    // MARK: - Properties

    var onLanguageSelected: ((String) -> Void)?
    private var selectedButton: UIButton?

    // MARK: - UI Components

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Profile.Language.title
        label.textColor = .label
        label.font = .systemFont(ofSize: Constants.titleFontSize, weight: .semibold)
        return label
    }()

    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [russianButton, englishButton])
        stack.axis = .horizontal
        stack.spacing = Constants.buttonSpacing
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var russianButton = makeLanguageButton(title: L10n.Profile.Language.russian)
    private lazy var englishButton = makeLanguageButton(title: L10n.Profile.Language.english)

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        layer.cornerRadius = Constants.cornerRadius
        backgroundColor = AppColors.cardBackground
        setupLayout()
        setupActions()
        let currentLanguage = LocalizationService.shared.currentLanguage
        selectButton(currentLanguage == "en" ? englishButton : russianButton)

        NotificationCenter.default.addObserver(
            forName: .themeDidChange,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard notification.object is UIUserInterfaceStyle else { return }
            self?.backgroundColor = AppColors.cardBackground
            self?.refreshInactiveButtons()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

private extension LanguageSelectorView {

    func makeLanguageButton(title: String) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.title = title
        config.image = UIImage(systemName: "globe")
        config.imagePlacement = .leading
        config.imagePadding = Constants.buttonImagePadding
        config.baseForegroundColor = .label
        config.background.cornerRadius = Constants.buttonCornerRadius
        config.background.backgroundColor = AppColors.inactiveButton
        return UIButton(configuration: config)
    }

    func selectButton(_ button: UIButton) {
        [russianButton, englishButton].forEach {
            var config = $0.configuration
            config?.baseForegroundColor = .label
            config?.background.backgroundColor = AppColors.inactiveButton
            $0.configuration = config
        }
        var config = button.configuration
        config?.baseForegroundColor = .white
        config?.background.backgroundColor = .systemBlue
        button.configuration = config
        selectedButton = button
    }

    func refreshInactiveButtons() {
        [russianButton, englishButton].forEach {
            guard $0 != selectedButton else { return }
            var config = $0.configuration
            config?.background.backgroundColor = AppColors.inactiveButton
            $0.configuration = config
        }
    }

    func setupLayout() {
        addSubview(titleLabel)
        addSubview(buttonStack)

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.contentInset)
            $0.leading.trailing.equalToSuperview().inset(Constants.contentInset)
        }

        buttonStack.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.titleToButtonSpacing)
            $0.leading.trailing.equalToSuperview().inset(Constants.contentInset)
            $0.bottom.equalToSuperview().inset(Constants.contentInset)
            $0.height.equalTo(Constants.buttonStackHeight)
        }
    }

    func setupActions() {
        russianButton.addTarget(self, action: #selector(russianTapped), for: .touchUpInside)
        englishButton.addTarget(self, action: #selector(englishTapped), for: .touchUpInside)
    }

    @objc func russianTapped() {
        selectButton(russianButton)
        onLanguageSelected?("ru")
    }

    @objc func englishTapped() {
        selectButton(englishButton)
        onLanguageSelected?("en")
    }
}

// MARK: - Constants

private extension LanguageSelectorView {
    enum Constants {
        static let cornerRadius: CGFloat = 16
        static let contentInset: CGFloat = 20
        static let titleFontSize: CGFloat = 17
        static let titleToButtonSpacing: CGFloat = 12
        static let buttonStackHeight: CGFloat = 44
        static let buttonSpacing: CGFloat = 8
        static let buttonCornerRadius: CGFloat = 10
        static let buttonImagePadding: CGFloat = 8
    }
}
