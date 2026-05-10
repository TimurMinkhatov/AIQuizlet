//
//  StatCardView.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 29/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

final class StatCardView: UIView {

    // MARK: - UI Components

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var headerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        return stack
    }()

    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        return label
    }()

    // MARK: - Init

    init(title: String, systemImage: String, tintColor: UIColor = .systemIndigo) {
        super.init(frame: .zero)
        backgroundColor = AppColors.cardBackground
        layer.cornerRadius = 16
        iconImageView.image = UIImage(systemName: systemImage)
        iconImageView.tintColor = tintColor
        titleLabel.text = title
        setupLayout()

        NotificationCenter.default.addObserver(
            forName: .themeDidChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.backgroundColor = AppColors.cardBackground
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func setValue(_ value: String) {
        valueLabel.text = value
    }
}

// MARK: - Private Methods

private extension StatCardView {

    func setupLayout() {
        headerStack.addArrangedSubview(iconImageView)
        headerStack.addArrangedSubview(titleLabel)

        addSubview(headerStack)
        addSubview(valueLabel)

        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }

        headerStack.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
        }

        valueLabel.snp.makeConstraints {
            $0.top.equalTo(headerStack.snp.bottom).offset(8)
            $0.leading.bottom.equalToSuperview().inset(16)
        }
    }
}
