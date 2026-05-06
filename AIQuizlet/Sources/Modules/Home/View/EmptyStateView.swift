//
//  EmptyStateView.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 13.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

final class EmptyStateView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let containerCornerRadius: CGFloat = 24
        static let iconContainerCornerRadius: CGFloat = 40
        static let iconContainerSize: CGFloat = 80
        static let iconImageSize: CGFloat = 45

        static let containerTopOffset: CGFloat = 30
        static let titleTopOffset: CGFloat = 20
        static let subtitleTopOffset: CGFloat = 8
        static let bottomOffset: CGFloat = 30
        static let horizontalInset: CGFloat = 20

        enum Fonts {
            static let title = UIFont.systemFont(ofSize: 18, weight: .semibold)
            static let subtitle = UIFont.systemFont(ofSize: 14)
        }

        enum Strings {
            static let title = "У вас пока нет тестов"
            static let subtitle = "Создайте первый тест!"
            static let iconName = "book"
        }
    }

    // MARK: - UI Elements

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.cardBackground
        view.layer.cornerRadius = Constants.containerCornerRadius
        return view
    }()

    private lazy var iconContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        view.layer.cornerRadius = Constants.iconContainerCornerRadius
        view.clipsToBounds = true
        return view
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: Constants.Strings.iconName)
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Home.Empty.title
        label.font = Constants.Fonts.title
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Home.Empty.subtitle
        label.font = Constants.Fonts.subtitle
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        NotificationCenter.default.addObserver(
            forName: .themeDidChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.containerView.backgroundColor = AppColors.cardBackground
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setupUI() {
        containerView.addSubviews(iconContainerView, titleLabel, subtitleLabel)
        iconContainerView.addSubview(iconImageView)
        addSubview(containerView)

        setupConstraints()
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        iconContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.containerTopOffset)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(Constants.iconContainerSize)
        }

        iconImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(Constants.iconImageSize)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconContainerView.snp.bottom).offset(Constants.titleTopOffset)
            $0.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.subtitleTopOffset)
            $0.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
            $0.bottom.equalToSuperview().offset(-Constants.bottomOffset)
        }
    }
}
