//
//  SplashViewController.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 08/05/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

final class SplashViewController: UIViewController {

    // MARK: - UI Components

    private lazy var splashImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "book")
        imageView.tintColor = AppColors.book
        return imageView
    }()

    private lazy var splashImageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.cardBackground
        view.layer.cornerRadius = Constants.containerCornerRadius
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = L10n.Splash.title
        label.textColor = .white
        label.font = .systemFont(ofSize: Constants.titleFontSize, weight: .semibold)
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Splash.subtitle
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()

    // MARK: - Init

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Lifecycle

extension SplashViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if traitCollection.userInterfaceStyle == .dark {
            view.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
            view.backgroundColor = AppColors.background
        } else {
            view.applyGradient(colors: AppColors.backgroundGradient)
        }
    }
}

// MARK: - Private Methods

private extension SplashViewController {

    func setupUI() {
        view.addSubviews(splashImageContainerView, titleLabel, subtitleLabel)
        splashImageContainerView.addSubview(splashImageView)

        splashImageContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.containerTopOffset)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(Constants.containerSize)
        }

        splashImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(Constants.iconSize)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(splashImageContainerView.snp.bottom).offset(Constants.titleTopOffset)
            $0.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.subtitleTopOffset)
            $0.centerX.equalToSuperview()
        }
    }
}

// MARK: - Constants

private extension SplashViewController {
    enum Constants {
        static let containerSize: CGFloat = 128
        static let containerTopOffset: CGFloat = 256
        static let containerCornerRadius: CGFloat = 32
        static let iconSize: CGFloat = 80
        static let titleFontSize: CGFloat = 20
        static let titleTopOffset: CGFloat = 32
        static let subtitleTopOffset: CGFloat = 8
        static let horizontalInset: CGFloat = 16
    }
}
