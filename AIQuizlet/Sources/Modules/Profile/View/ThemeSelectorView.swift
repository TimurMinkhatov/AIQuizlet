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
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()

    private lazy var lightButton = makeThemeButton(title: L10n.Profile.Theme.light, systemImage: "sun.max")
    private lazy var darkButton = makeThemeButton(title: L10n.Profile.Theme.dark, systemImage: "moon")
    private lazy var systemButton = makeThemeButton(title: L10n.Profile.Theme.system, systemImage: "desktopcomputer")

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        layer.cornerRadius = 16
        setupLayout()
        setupActions()
        selectButton(lightButton)
        updateCardBackground()

        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { [weak self] (view: ThemeSelectorView, _) in
            self?.updateCardBackground()
            self?.refreshInactiveButtons()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

private extension ThemeSelectorView {

    func inactiveButtonColor() -> UIColor {
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(hex: "364153").withAlphaComponent(0.5)
            : .systemGray5
    }

    func updateCardBackground() {
        backgroundColor = traitCollection.userInterfaceStyle == .dark
            ? UIColor(hex: "1e2939")
            : .secondarySystemGroupedBackground
    }

    func refreshInactiveButtons() {
        [lightButton, darkButton, systemButton].forEach {
            guard $0 != selectedButton else { return }
            var config = $0.configuration
            config?.background.backgroundColor = inactiveButtonColor()
            $0.configuration = config
        }
    }

    func makeThemeButton(title: String, systemImage: String) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: systemImage)?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 16))
        config.imagePlacement = .top
        config.imagePadding = 4
        config.baseForegroundColor = .label
        config.background.cornerRadius = 10
        config.background.backgroundColor = inactiveButtonColor()
        var titleAttr = AttributedString(title)
        titleAttr.font = .systemFont(ofSize: 12)
        config.attributedTitle = titleAttr
        return UIButton(configuration: config)
    }

    func selectButton(_ button: UIButton) {
        [lightButton, darkButton, systemButton].forEach {
            var config = $0.configuration
            config?.baseForegroundColor = .label
            config?.background.backgroundColor = inactiveButtonColor()
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
        buttonStack.spacing = 8
        buttonStack.distribution = .fillEqually

        addSubview(titleLabel)
        addSubview(buttonStack)

        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(20)
        }

        buttonStack.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(64)
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
