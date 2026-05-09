//
//  ThemeSelectorView.swift
//  AIQuizlet
//

import UIKit
import SnapKit

final class ThemeSelectorView: UIView {

    // MARK: - Properties

    var onThemeSelected: ((UIUserInterfaceStyle) -> Void)?
    private var selectedButton: UIButton?

    // MARK: - UI Components

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Profile.Theme.title
        label.textColor = .label
        label.font = .systemFont(ofSize: Constants.titleFontSize, weight: .semibold)
        return label
    }()

    private lazy var lightButton = makeThemeButton(title: L10n.Profile.Theme.light, systemImage: "sun.max")
    private lazy var darkButton = makeThemeButton(title: L10n.Profile.Theme.dark, systemImage: "moon")
    private lazy var systemButton = makeThemeButton(title: L10n.Profile.Theme.system, systemImage: "desktopcomputer")

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        layer.cornerRadius = Constants.cornerRadius
        backgroundColor = AppColors.cardBackground
        setupLayout()
        setupActions()
        selectButton(lightButton)

        NotificationCenter.default.addObserver(
            forName: .themeDidChange,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.backgroundColor = AppColors.cardBackground
            self?.refreshInactiveButtons()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

private extension ThemeSelectorView {

    func refreshInactiveButtons() {
        [lightButton, darkButton, systemButton].forEach {
            guard $0 != selectedButton else { return }
            var config = $0.configuration
            config?.background.backgroundColor = AppColors.inactiveButton
            $0.configuration = config
        }
    }

    func makeThemeButton(title: String, systemImage: String) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: systemImage)?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: Constants.buttonIconSize))
        config.imagePlacement = .top
        config.imagePadding = Constants.buttonImagePadding
        config.baseForegroundColor = .label
        config.background.cornerRadius = Constants.buttonCornerRadius
        config.background.backgroundColor = AppColors.inactiveButton
        var titleAttr = AttributedString(title)
        titleAttr.font = .systemFont(ofSize: Constants.buttonTitleFontSize)
        config.attributedTitle = titleAttr
        return UIButton(configuration: config)
    }

    func selectButton(_ button: UIButton) {
        [lightButton, darkButton, systemButton].forEach {
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

    func setupLayout() {
        let buttonStack = UIStackView(arrangedSubviews: [lightButton, darkButton, systemButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = Constants.buttonSpacing
        buttonStack.distribution = .fillEqually

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
        lightButton.addTarget(self, action: #selector(lightTapped), for: .touchUpInside)
        darkButton.addTarget(self, action: #selector(darkTapped), for: .touchUpInside)
        systemButton.addTarget(self, action: #selector(systemTapped), for: .touchUpInside)
    }

    @objc func lightTapped() {
        selectButton(lightButton)
        onThemeSelected?(.light)
    }

    @objc func darkTapped() {
        selectButton(darkButton)
        onThemeSelected?(.dark)
    }

    @objc func systemTapped() {
        selectButton(systemButton)
        onThemeSelected?(.unspecified)
    }
}

// MARK: - Constants

private extension ThemeSelectorView {
    enum Constants {
        static let cornerRadius: CGFloat = 16
        static let contentInset: CGFloat = 20
        static let titleFontSize: CGFloat = 17
        static let titleToButtonSpacing: CGFloat = 12
        static let buttonStackHeight: CGFloat = 72
        static let buttonSpacing: CGFloat = 8
        static let buttonCornerRadius: CGFloat = 10
        static let buttonIconSize: CGFloat = 16
        static let buttonImagePadding: CGFloat = 4
        static let buttonTitleFontSize: CGFloat = 12
    }
}
