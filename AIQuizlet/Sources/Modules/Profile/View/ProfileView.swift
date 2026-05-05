//
//  ProfileView.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 01/05/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

final class ProfileView: UIView {

    // MARK: - UI Components

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Profile.title
        label.font = .systemFont(ofSize: Constants.nameFontSize, weight: .bold)
        return label
    }()

    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.emailFontSize)
        label.textColor = .secondaryLabel
        return label
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

    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .white
        return imageView
    }()

    private lazy var profileContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.avatarCornerRadius
        view.clipsToBounds = true
        return view
    }()

    private lazy var infoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.infoStackSpacing
        return stack
    }()

    private lazy var profileCardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.cardCornerRadius
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()

        NotificationCenter.default.addObserver(
            forName: .themeDidChange,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let style = notification.object as? UIUserInterfaceStyle else { return }
            self?.updateGradient(for: style)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func configure(with viewModel: ProfileViewModel) {
        emailLabel.text = viewModel.email
    }
}

// MARK: - Lifecycle

extension ProfileView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileContainerView.layoutIfNeeded()
        avatarGradientLayer.frame = profileContainerView.bounds
        avatarGradientLayer.cornerRadius = profileContainerView.layer.cornerRadius
        profileCardView.backgroundColor = AppColors.cardBackground
    }
}

// MARK: - Private Methods

private extension ProfileView {
    func setupLayout() {
        addSubview(profileCardView)
        profileCardView.addSubview(profileContainerView)
        profileContainerView.layer.insertSublayer(avatarGradientLayer, at: 0)
        profileContainerView.addSubview(profileImageView)
        profileCardView.addSubview(infoStack)
        infoStack.addArrangedSubview(nameLabel)
        infoStack.addArrangedSubview(emailLabel)

        profileImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(Constants.iconSize)
        }

        infoStack.snp.makeConstraints {
            $0.leading.equalTo(profileContainerView.snp.trailing).offset(Constants.infoStackLeadingOffset)
            $0.trailing.equalToSuperview().inset(Constants.horizontalInset)
            $0.centerY.equalTo(profileContainerView)
        }

        profileContainerView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.horizontalInset)
            $0.top.bottom.equalToSuperview().inset(Constants.avatarVerticalInset)
            $0.width.height.equalTo(Constants.avatarSize)
        }

        profileCardView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func updateGradient(for style: UIUserInterfaceStyle) {
        avatarGradientLayer.isHidden = style == .dark
        profileContainerView.backgroundColor = style == .dark ? .systemGray3 : .clear
        profileCardView.backgroundColor = AppColors.cardBackground
    }
}

// MARK: - Constants

private extension ProfileView {
    enum Constants {
        static let nameFontSize: CGFloat = 20
        static let emailFontSize: CGFloat = 14
        static let avatarCornerRadius: CGFloat = 40
        static let avatarSize: CGFloat = 80
        static let avatarVerticalInset: CGFloat = 24
        static let iconSize: CGFloat = 30
        static let cardCornerRadius: CGFloat = 20
        static let infoStackSpacing: CGFloat = 4
        static let infoStackLeadingOffset: CGFloat = 16
        static let horizontalInset: CGFloat = 16
    }
}
