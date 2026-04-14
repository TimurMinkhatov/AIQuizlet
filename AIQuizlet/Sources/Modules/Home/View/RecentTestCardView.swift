//
//  RecentTestCardView.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 13.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//
import UIKit

final class RecentTestCardView: UIView {
    private let titleLabel = UILabel()
    
    private let scoreLabel = UILabel()
    
    init(test: RecentTest) {
        super.init(frame: .zero)
        setupView(test: test)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(test: RecentTest) {
        backgroundColor = .white
        layer.cornerRadius = 16
        
        titleLabel.text = test.title
        scoreLabel.text = test.score
        scoreLabel.textColor = .gray
        
        addSubview(titleLabel)
        addSubview(scoreLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview().inset(16)
        }
        scoreLabel.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview().inset(16)
        }
        self.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
    }
}
