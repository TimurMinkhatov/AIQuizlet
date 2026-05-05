//
//  HistoryView.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 05.05.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

final class HistoryView: UITableViewCell {
    
    static let identifier = "HistoryCell"
    
    // MARK: - Constants
    
    private enum Constants {
        static let containerCornerRadius: CGFloat = 16
        static let indicatorSize: CGFloat = 12
        static let indicatorCornerRadius: CGFloat = 6
        static let scoreMinWidth: CGFloat = 45
        
        enum Constraints {
            static let verticalInset: CGFloat = 8
            static let horizontalInset: CGFloat = 16
            static let contentPadding: CGFloat = 16
            static let interElementSpacing: CGFloat = 8
        }
        
        enum Fonts {
            static let title = UIFont.systemFont(ofSize: 16, weight: .semibold)
            static let subtitle = UIFont.systemFont(ofSize: 13, weight: .regular)
            static let score = UIFont.systemFont(ofSize: 14, weight: .medium)
        }
    }
    
    // MARK: - UI Elements
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.containerCornerRadius
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.title
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.subtitle
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var statusIndicatorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.indicatorCornerRadius
        return view
    }()
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.score
        label.textAlignment = .right
        label.textColor = .black
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with result: QuizResult) {
        titleLabel.text = result.quiz.title
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ru_RU")
        let dateString = formatter.string(from: result.date)
        
        subtitleLabel.text = "\(dateString) • \(result.totalQuestions) вопросов"
        
        let percentage = result.percentage
        scoreLabel.text = "\(Int(percentage))%"
        
        updateStatusColor(percentage: percentage)
    }
    
    
    
    // MARK: - Private Methods
    
    private func updateStatusColor(percentage: Double) {
        if percentage >= 80 {
            statusIndicatorView.backgroundColor = .systemGreen
        } else if percentage >= 50 {
            statusIndicatorView.backgroundColor = .systemYellow
        } else {
            statusIndicatorView.backgroundColor = .systemRed
        }
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(containerView)
        containerView.addSubviews(titleLabel, subtitleLabel, statusIndicatorView, scoreLabel)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.Constraints.verticalInset)
            $0.leading.trailing.equalToSuperview().inset(Constants.Constraints.horizontalInset)
        }
        
        scoreLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Constants.Constraints.contentPadding)
            $0.trailing.equalToSuperview().inset(Constants.Constraints.contentPadding)
            $0.width.equalTo(Constants.scoreMinWidth)
        }
        
        statusIndicatorView.snp.makeConstraints {
            $0.centerY.equalTo(scoreLabel.snp.centerY)
            $0.trailing.equalTo(scoreLabel.snp.leading).offset(-Constants.Constraints.interElementSpacing)
            $0.size.equalTo(Constants.indicatorSize)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Constants.Constraints.contentPadding)
            $0.leading.equalToSuperview().inset(Constants.Constraints.contentPadding)
            $0.trailing.equalTo(statusIndicatorView.snp.leading).offset(-Constants.Constraints.interElementSpacing)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.Constraints.interElementSpacing)
            $0.leading.equalToSuperview().inset(Constants.Constraints.contentPadding)
            $0.bottom.equalToSuperview().inset(Constants.Constraints.contentPadding)
            $0.trailing.equalTo(statusIndicatorView.snp.leading).offset(-Constants.Constraints.interElementSpacing)
        }
    }
}
