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
    var onTap: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .systemGray
        return label
    }()
    
    private let statusIndicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        return view
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .right
        return label
    }()
    
    init(test: RecentTest) {
        super.init(frame: .zero)
        setupView(test: test)
        setupGesture()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

private extension RecentTestCardView {
    
    func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.isUserInteractionEnabled = true
        addGestureRecognizer(tap)
    }
    
    @objc func handleTap() { onTap?() }
    
    func updateStatusColor(percentage: Double) {
        if percentage >= 80 {
            statusIndicator.backgroundColor = .systemGreen
        } else if percentage >= 50 {
            statusIndicator.backgroundColor = .systemYellow
        } else {
            statusIndicator.backgroundColor = .systemRed
        }
    }
    
    
    func setupView(test: RecentTest) {
        backgroundColor = .white
        layer.cornerRadius = 20
        
        titleLabel.text = test.title
        scoreLabel.text = "\(Int(test.percentage))%"
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ru_RU")
        dateLabel.text = formatter.string(from: test.date)
        updateStatusColor(percentage: test.percentage)
        
        addSubviews(titleLabel, dateLabel, statusIndicator, scoreLabel)
        
        setupConstraints()
        
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.trailing.lessThanOrEqualTo(statusIndicator.snp.leading).offset(-10)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(16)
        }

        scoreLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.greaterThanOrEqualTo(45)
        }

        statusIndicator.snp.makeConstraints { make in
            make.trailing.equalTo(scoreLabel.snp.leading).offset(-8)
            make.centerY.equalTo(scoreLabel)
            make.size.equalTo(12)
        }
    }
}
