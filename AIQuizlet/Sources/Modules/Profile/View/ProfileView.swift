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
    
    // MARK: - Properties
    
    private let viewModel: ProfileViewModel
    
    // MARK: - UI Components
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Profile.title
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
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
        view.layer.cornerRadius = 40
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var infoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private lazy var profileCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 20
        return view
    }()
    
    // MARK: - Init
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupLayout()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Lifecycle

extension ProfileView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileContainerView.layoutIfNeeded()
        avatarGradientLayer.frame = profileContainerView.bounds
        avatarGradientLayer.cornerRadius = profileContainerView.layer.cornerRadius
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
            $0.width.height.equalTo(30)
        }
        
        infoStack.snp.makeConstraints {
            $0.leading.equalTo(profileContainerView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(profileContainerView)
        }
        
        profileContainerView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.bottom.equalToSuperview().inset(24)
            $0.width.height.equalTo(80)
        }
        
        profileCardView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func updateUI() {
        emailLabel.text = viewModel.email
    }
}
