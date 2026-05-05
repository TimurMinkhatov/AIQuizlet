//
//  QuizOptionButton.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 14.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

final class QuizOptionButton: UIControl {

    // MARK: - Enums

    enum State {
        case normal
        case selected
        case correct
        case wrong
    }

    private enum Constants {
        static let labelLeading = 16
        static let labelTrailing = 8
        static let iconImageViewTrailing = 16
        static let iconImageViewSize = 20
    }

    // MARK: - UI Elements

    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()

    private lazy var iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        return iv
    }()

    // MARK: - Properties

    var title: String? {
        didSet { label.text = title }
    }

    override var isHighlighted: Bool {
        didSet { alpha = isHighlighted ? 0.7 : 1.0 }
    }

    private var currentState: State = .normal

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        backgroundColor = AppColors.cardBackground

        NotificationCenter.default.addObserver(
            forName: .themeDidChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            if self?.currentState == .normal {
                self?.backgroundColor = AppColors.cardBackground
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func updateState(_ state: State) {
        currentState = state
        iconImageView.isHidden = (state == .normal || state == .selected)
        label.font = (state == .selected)
            ? .systemFont(ofSize: 15, weight: .bold)
            : .systemFont(ofSize: 15, weight: .medium)
        layer.borderWidth = (state == .selected) ? 3 : 1.5

        switch state {
        case .normal:
            applyResultStyle(
                background: AppColors.cardBackground,
                border: .systemGray4,
                icon: "",
                tint: .clear
            )
            label.textColor = .label
            layer.borderWidth = 1
            
        case .selected:
            applyResultStyle(
                background: .systemBlue.withAlphaComponent(0.05),
                border: .systemBlue,
                icon: "",
                tint: .clear
            )
            label.textColor = .label
            
        case .correct:
            applyResultStyle(
                background: AppColors.correctBackground,
                border: .systemGreen,
                icon: "checkmark.circle.fill",
                tint: .systemGreen
            )
            
        case .wrong:
            applyResultStyle(
                background: AppColors.wrongBackground,
                border: .systemRed,
                icon: "xmark.circle.fill",
                tint: .systemRed
            )
        }
    }
}

// MARK: - Setup Logic

private extension QuizOptionButton {

    func setup() {
        backgroundColor = AppColors.cardBackground
        layer.cornerRadius = 12
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.systemGray4.cgColor

        addSubview(label)
        addSubview(iconImageView)

        setupConstraints()
    }

    func setupConstraints() {
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Constants.labelLeading)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(iconImageView.snp.leading).offset(-Constants.labelTrailing)
        }

        iconImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Constants.iconImageViewTrailing)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(Constants.iconImageViewSize)
        }
    }

    func applyResultStyle(background: UIColor, border: UIColor, icon: String, tint: UIColor) {
        backgroundColor = background
        layer.borderColor = border.cgColor
        iconImageView.image = icon.isEmpty ? nil : UIImage(systemName: icon)
        iconImageView.tintColor = tint
    }
}
