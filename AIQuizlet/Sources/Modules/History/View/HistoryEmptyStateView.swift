//
//  HistoryEmptyStateView.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 05.05.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

final class HistoryEmptyStateView: UIView {
    
    // MARK: - Constants
    
    private enum Constants {
        static let containerCornerRadius: CGFloat = 24
        static let iconContainerSize: CGFloat = 90
        static let iconContainerCornerRadius: CGFloat = 45
        static let iconSize: CGFloat = 45
        static let homeButtonWidth: CGFloat = 160
        static let homeButtonHeight: CGFloat = 50
        
        enum Constraints {
            static let containerHorizontalInset: CGFloat = 24
            static let iconTopOffset: CGFloat = 40
            static let titleTopOffset: CGFloat = 24
            static let textHorizontalInset: CGFloat = 16
            static let subtitleTopOffset: CGFloat = 8
            static let buttonTopOffset: CGFloat = 32
            static let containerBottomPadding: CGFloat = 40
        }
        
        enum Colors {
            static let iconBackground = UIColor(red: 236/255, green: 238/255, blue: 242/255, alpha: 1)
            static let buttonBackground = UIColor(red: 108/255, green: 71/255, blue: 255/255, alpha: 1)
            static let iconTint = UIColor.systemGray2
            static let subtitleText = UIColor.systemGray
        }
    }
    
    // MARK: - Properties
    
    var onHomeTapped: (() -> Void)?
    
    // MARK: - UI Elements
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.historyCard
        view.layer.cornerRadius = Constants.containerCornerRadius
        return view
    }()
    
    private lazy var iconContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.iconBackground
        view.layer.cornerRadius = Constants.iconContainerCornerRadius
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "book"))
        imageView.tintColor = Constants.Colors.iconTint
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.History.Search.no
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.History.Create.first
        label.font = .systemFont(ofSize: 15)
        label.textColor = Constants.Colors.subtitleText
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var homeButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = L10n.History.toHome
        config.baseBackgroundColor = Constants.Colors.buttonBackground
        config.baseForegroundColor = .white
        config.cornerStyle = .large
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(homeAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Actions
    
    @objc private func homeAction() {
        onHomeTapped?()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubviews(iconContainer, titleLabel, subtitleLabel, homeButton)
        iconContainer.addSubview(iconImageView)
        
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Constants.Constraints.containerHorizontalInset)
        }
        
        iconContainer.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.Constraints.iconTopOffset)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(Constants.iconContainerSize)
        }
        
        iconImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(Constants.iconSize)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconContainer.snp.bottom).offset(Constants.Constraints.titleTopOffset)
            $0.leading.trailing.equalToSuperview().inset(Constants.Constraints.textHorizontalInset)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.Constraints.subtitleTopOffset)
            $0.leading.trailing.equalToSuperview().inset(Constants.Constraints.textHorizontalInset)
        }
        
        homeButton.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(Constants.Constraints.buttonTopOffset)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(Constants.homeButtonWidth)
            $0.height.equalTo(Constants.homeButtonHeight)
            $0.bottom.equalToSuperview().offset(-Constants.Constraints.containerBottomPadding)
        }
    }
}
