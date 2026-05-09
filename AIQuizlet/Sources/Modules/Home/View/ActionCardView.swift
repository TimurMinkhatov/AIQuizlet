//
//  ActionCardView.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 12.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

final class ActionCardView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let cardCornerRadius: CGFloat = 24
        static let shadowOpacity: Float = 0.08
        static let shadowRadius: CGFloat = 12
        static let shadowOffset = CGSize(width: 0, height: 4)

        static let iconContainerSize: CGFloat = 80
        static let iconImageSize: CGFloat = 45
        static let iconTopOffset: CGFloat = 24

        static let textTopOffset: CGFloat = 12
        static let textHorizontalInset: CGFloat = 8
        static let subtitleTopOffset: CGFloat = 8
        static let subtitleHorizontalInset: CGFloat = 24
        static let bottomInset: CGFloat = 24

        enum Fonts {
            static let title = UIFont.systemFont(ofSize: 18, weight: .semibold)
            static let subtitle = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
    }

    // MARK: - Properties

    var action: (() -> Void)?
    private let gradientColors: [UIColor]

    // MARK: - UI Elements

    private lazy var iconContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = Constants.Fonts.title
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = Constants.Fonts.subtitle
        label.textColor = .systemGray
        return label
    }()

    // MARK: - Init

    init(title: String, subtitle: String, iconName: String, gradientColors: [UIColor]) {
        self.gradientColors = gradientColors
        super.init(frame: .zero)
        titleLabel.text = title
        subtitleLabel.text = subtitle
        imageView.image = UIImage(systemName: iconName)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        iconContainerView.applyGradient(
            colors: gradientColors,
            startPoint: CGPoint(x: 0, y: 0),
            endPoint: CGPoint(x: 1, y: 1),
            cornerRadius: iconContainerView.frame.height / 2
        )
    }
}

// MARK: - Private Methods

private extension ActionCardView {

    func setupView() {
        backgroundColor = AppColors.cardBackground
        layer.cornerRadius = Constants.cardCornerRadius
        setupShadow()

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true

        addSubviews(iconContainerView, titleLabel, subtitleLabel)
        iconContainerView.addSubview(imageView)

        setupConstraints()
    }

    func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowOffset = Constants.shadowOffset
        layer.shadowRadius = Constants.shadowRadius

        NotificationCenter.default.addObserver(
            forName: .themeDidChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.backgroundColor = AppColors.cardBackground
        }
    }

    @objc func handleTap() {
        action?()
    }

    func setupConstraints() {
        iconContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.iconTopOffset)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(Constants.iconContainerSize)
        }

        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(Constants.iconImageSize)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconContainerView.snp.bottom).offset(Constants.textTopOffset)
            $0.leading.trailing.equalToSuperview().inset(Constants.textHorizontalInset)
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.subtitleTopOffset)
            $0.leading.trailing.equalToSuperview().inset(Constants.subtitleHorizontalInset)
            $0.bottom.equalToSuperview().inset(Constants.bottomInset)
        }
    }
}
