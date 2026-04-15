//
//  ActionCardView.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 12.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//
import UIKit
import SnapKit

class ActionCardView: UIView {
    
    var action: (() -> Void)?
    private lazy var gradientLayer = CAGradientLayer()
    
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
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    init(title: String, subtitle: String, iconName: String, gradientColors: [UIColor]) {
        super.init(frame: .zero)
        textLabel.text = title
        subtitleLabel.text = subtitle
        imageView.image = UIImage(systemName: iconName)
        
        gradientLayer.colors = gradientColors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        setupView()
        setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconContainerView.layer.cornerRadius = iconContainerView.frame.height / 2
        gradientLayer.frame = iconContainerView.bounds
    }
    
    @objc private func handleTup() {
        action?()
        
    }
    
    private func setupView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTup))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        
        backgroundColor = .white
        layer.cornerRadius = 24
        
        addSubview(iconContainerView)
        iconContainerView.layer.addSublayer(gradientLayer)
        iconContainerView.addSubview(imageView)
        
        addSubview(textLabel)
        addSubview(subtitleLabel)
        
        setupConstraints()
        textLabel.textAlignment = .center
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 12
        
    }
    
    private func setupConstraints() {
        
        iconContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.size.equalTo(80)
        }
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(45)
        }
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(iconContainerView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-24)
        }
        
    }
    
}
