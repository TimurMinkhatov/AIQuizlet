//
//  PhotoPreviewView.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 27.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

final class PhotoPreviewView: UIView {
    
    // MARK: - Constants
    
    private enum Constants {
        static let questionCounts: [Int] = [5, 10, 15, 20]
        static let buttonCornerRadius: CGFloat = 16
        static let questionButtonCornerRadius: CGFloat = 10
        static let questionCountTitle = "Количество вопросов"
    }
    
    // MARK: - Properties
    
    private let activeQuestionGradient = CAGradientLayer()
    private let continueButtonGradient = CAGradientLayer()
    private var questionButtons: [UIButton] = []
    private(set) var selectedQuestionCount: Int = 5
    
    // MARK: - UI Elements
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var glassPanel: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.layer.cornerRadius = 32
        view.clipsToBounds = true
        return view
    }()

    private lazy var questionCountTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.questionCountTitle
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var questionCountStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var retakeButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Переснять"
        config.image = UIImage(systemName: "arrow.counterclockwise")
        config.imagePadding = 8
        config.baseForegroundColor = .white
        config.background.cornerRadius = Constants.buttonCornerRadius
        config.background.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
        let button = UIButton(configuration: config)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        button.layer.cornerRadius = Constants.buttonCornerRadius
        return button
    }()
    
    lazy var continueButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Продолжить"
        config.image = UIImage(systemName: "checkmark")
        config.imagePadding = 8
        config.baseForegroundColor = .white
        config.background.cornerRadius = Constants.buttonCornerRadius
        config.background.backgroundColor = .clear
        return UIButton(configuration: config)
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = .white
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    // MARK: - Init
    
    init(image: UIImage) {
        super.init(frame: .zero)
        imageView.image = image
        setupUI()
        setupQuestionButtons()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradients()
    }
    
    // MARK: - Public Methods
    
    func showLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            continueButton.configuration?.showsActivityIndicator = true
            continueButton.configuration?.title = ""
            continueButtonGradient.isHidden = true
            continueButton.isEnabled = false
        } else {
            activityIndicator.stopAnimating()
            continueButton.configuration?.showsActivityIndicator = false
            continueButton.configuration?.title = "Продолжить"
            continueButtonGradient.isHidden = false
            continueButton.isEnabled = true
        }
    }
}

// MARK: - Private Methods

private extension PhotoPreviewView {
    
    func setupUI() {
        backgroundColor = .black
        addSubview(imageView)
        addSubview(glassPanel)
        
        glassPanel.contentView.addSubview(questionCountTitleLabel)
        glassPanel.contentView.addSubview(questionCountStackView)
        glassPanel.contentView.addSubview(retakeButton)
        glassPanel.contentView.addSubview(continueButton)
        continueButton.addSubview(activityIndicator)
    }
    
    func setupQuestionButtons() {
        Constants.questionCounts.forEach { count in
            let button = UIButton(type: .system)
            button.setTitle("\(count)", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            button.layer.cornerRadius = Constants.questionButtonCornerRadius
            button.tag = count
            button.backgroundColor = .white.withAlphaComponent(0.1)
            button.setTitleColor(.white.withAlphaComponent(0.7), for: .normal)
            button.addTarget(self, action: #selector(questionCountTapped(_:)), for: .touchUpInside)
            
            questionButtons.append(button)
            questionCountStackView.addArrangedSubview(button)
        }
        selectedQuestionCount = 5
    }
    
    @objc func questionCountTapped(_ sender: UIButton) {
        selectedQuestionCount = sender.tag
        updateSelection()
    }
    
    func updateSelection() {
        questionButtons.forEach {
            $0.backgroundColor = .white.withAlphaComponent(0.1)
            $0.setTitleColor(.white.withAlphaComponent(0.7), for: .normal)
        }
        setNeedsLayout()
    }
    
    func updateGradients() {
        let colors = [
            UIColor(red: 21/255, green: 93/255, blue: 252/255, alpha: 1).cgColor,
            UIColor(red: 152/255, green: 16/255, blue: 250/255, alpha: 1).cgColor,
        ]
        
        continueButtonGradient.colors = colors
        continueButtonGradient.startPoint = CGPoint(x: 0, y: 0.5)
        continueButtonGradient.endPoint = CGPoint(x: 1, y: 0.5)
        continueButtonGradient.frame = continueButton.bounds
        continueButtonGradient.cornerRadius = Constants.buttonCornerRadius
        
        if continueButtonGradient.superlayer == nil {
            continueButton.layer.insertSublayer(continueButtonGradient, at: 0)
        }
        
        if let activeButton = questionButtons.first(where: { $0.tag == selectedQuestionCount }) {
            activeQuestionGradient.colors = colors
            activeQuestionGradient.startPoint = CGPoint(x: 0, y: 0.5)
            activeQuestionGradient.endPoint = CGPoint(x: 1, y: 0.5)
            activeQuestionGradient.frame = activeButton.bounds
            activeQuestionGradient.cornerRadius = Constants.questionButtonCornerRadius
            
            activeButton.backgroundColor = .clear
            activeButton.setTitleColor(.white, for: .normal)
            
            if activeQuestionGradient.superlayer != activeButton.layer {
                activeButton.layer.insertSublayer(activeQuestionGradient, at: 0)
            }
        }
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        glassPanel.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(230)
        }

        questionCountTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(20)
        }
        
        questionCountStackView.snp.makeConstraints { make in
            make.top.equalTo(questionCountTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        retakeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(30)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(54)
            make.trailing.equalTo(self.snp.centerX).offset(-8)
        }
        
        continueButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(30)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(54)
            make.leading.equalTo(self.snp.centerX).offset(8)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
