//
//  QuizOptionButton.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 14.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//
import UIKit
import SnapKit

final class QuizOptionButton: UIControl {
    
    // MARK: enum State
    
    enum State {
        case normal
        case selected
        case correct
        case wrong
    }
    
    // MARK: - UI Elements
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        return iv
    }()
    
    // MARK: - Properties
    
    var title: String? {
        didSet { label.text = title }
    }
    
    override var isHighlighted: Bool {
        didSet { alpha = isHighlighted ? 0.7 : 1.0 }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func updateState(_ state: State) {
        iconImageView.isHidden = (state == .normal || state == .selected)
        label.textColor = .label
        backgroundColor = .white
        
        switch state {
        case .normal:
            layer.borderColor = UIColor.systemGray4.cgColor
            layer.borderWidth = 1
            
        case .selected:
            layer.borderColor = UIColor.systemBlue.cgColor
            layer.borderWidth = 2
            backgroundColor = UIColor.systemBlue.withAlphaComponent(0.05)
            
        case .correct:
            backgroundColor = UIColor(red: 232/255, green: 255/255, blue: 238/255, alpha: 1)
            layer.borderColor = UIColor.systemGreen.cgColor
            iconImageView.image = UIImage(systemName: "checkmark.circle.fill")
            iconImageView.tintColor = .systemGreen
            
        case .wrong:
            backgroundColor = UIColor(red: 255/255, green: 232/255, blue: 232/255, alpha: 1)
            layer.borderColor = UIColor.systemRed.cgColor
            iconImageView.image = UIImage(systemName: "xmark.circle.fill")
            iconImageView.tintColor = .systemRed
        }
    }
}

// MARK: - Setup Logic

private extension QuizOptionButton {
    
    func setup() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.systemGray4.cgColor
        
        addSubview(label)
        addSubview(iconImageView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(iconImageView.snp.leading).offset(-8)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
    }
}
