//
//  RecentTestCardView.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 13.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

final class RecentTestCardView: UIView {
    
    // MARK: - Constants
    
    private enum Constants {
        // Layout
        static let cornerRadius: CGFloat = 20
        static let indicatorCornerRadius: CGFloat = 6
        static let indicatorSize: CGFloat = 12
        
        // Insets
        static let standardInset: CGFloat = 16
        static let smallInset: CGFloat = 8
        static let spacing: CGFloat = 4
        
        // Font sizes
        static let titleFontSize: CGFloat = 16
        static let dateFontSize: CGFloat = 13
        static let scoreFontSize: CGFloat = 14
        
        // Score label
        static let scoreMinWidth: CGFloat = 45
        
        // Percentage thresholds
        static let excellentThreshold: Double = 80
        static let goodThreshold: Double = 50
    }
    
    // MARK: - Properties
    
    var onTap: (() -> Void)?
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.titleFontSize, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.dateFontSize)
        label.textColor = .systemGray
        return label
    }()
    
    private let statusIndicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.indicatorCornerRadius
        return view
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.scoreFontSize, weight: .medium)
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Init
    
    init(test: RecentTest) {
        super.init(frame: .zero)
        setupView(test: test)
        setupGesture()
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
}

// MARK: - Private Methods

private extension RecentTestCardView {
    
    func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        onTap?()
    }
    
    func updateStatusColor(percentage: Double) {
        switch percentage {
        case Constants.excellentThreshold...100:
            statusIndicator.backgroundColor = .systemGreen
        case Constants.goodThreshold..<Constants.excellentThreshold:
            statusIndicator.backgroundColor = .systemYellow
        default:
            statusIndicator.backgroundColor = .systemRed
        }
    }
    
    func setupView(test: RecentTest) {
        backgroundColor = AppColors.cardBackground
        layer.cornerRadius = Constants.cornerRadius
        
        titleLabel.text = test.title
        scoreLabel.text = "\(Int(test.percentage))%"
        dateLabel.text = test.date.formattedForHistory()
        updateStatusColor(percentage: test.percentage)
        
        addSubviews(titleLabel, dateLabel, statusIndicator, scoreLabel)
        setupConstraints()
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(Constants.standardInset)
            $0.trailing.lessThanOrEqualTo(statusIndicator.snp.leading).offset(-Constants.smallInset)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.spacing)
            $0.leading.equalTo(titleLabel)
            $0.bottom.equalToSuperview().inset(Constants.standardInset)
        }

        scoreLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Constants.standardInset)
            $0.centerY.equalToSuperview()
            $0.width.greaterThanOrEqualTo(Constants.scoreMinWidth)
        }

        statusIndicator.snp.makeConstraints {
            $0.trailing.equalTo(scoreLabel.snp.leading).offset(-Constants.smallInset)
            $0.centerY.equalTo(scoreLabel)
            $0.size.equalTo(Constants.indicatorSize)
        }
    }
}
