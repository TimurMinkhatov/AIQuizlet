//
//  LanguageSelectorView.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 29/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
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
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [russianButton, englishButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var russianButton = makeLanguageButton(title: L10n.Profile.Language.russian)
    private lazy var englishButton = makeLanguageButton(title: L10n.Profile.Language.english)

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 16
        setupLayout()
        setupActions()
        selectButton(russianButton)
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
        config.imagePadding = 8
        config.baseForegroundColor = .label
        config.background.cornerRadius = 10
        config.background.backgroundColor = .systemGray5
        return UIButton(configuration: config)
    }

    func selectButton(_ button: UIButton) {
        [russianButton, englishButton].forEach {
            var config = $0.configuration
            config?.baseForegroundColor = .label
            config?.background.backgroundColor = .systemGray5
            $0.configuration = config
        }
        var config = button.configuration
        config?.baseForegroundColor = .white
        config?.background.backgroundColor = .systemBlue
        button.configuration = config
        selectedButton = button
    }

    func setupLayout() {

        addSubview(titleLabel)
        addSubview(buttonStack)

        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }

        buttonStack.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(44)
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
