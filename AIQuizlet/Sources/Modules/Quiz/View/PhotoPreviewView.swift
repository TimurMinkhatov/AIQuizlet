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
        static let defaultQuestionCount: Int = 5
        static let gradient: [UIColor] = [
            UIColor(red: 21/255, green: 93/255, blue: 252/255, alpha: 1),
            UIColor(red: 152/255, green: 16/255, blue: 250/255, alpha: 1)
        ]
        
        enum Layout {
            static let glassPanelBottom: CGFloat = 16
            static let glassPanelHeight: CGFloat = 230
            static let horizontalInset: CGFloat = 16
            static let innerPadding: CGFloat = 20
            static let stackSpacing: CGFloat = 10
            static let buttonSpacing: CGFloat = 8
            static let topOffset: CGFloat = 24
            static let titleBottomOffset: CGFloat = 12
            static let buttonBottomInset: CGFloat = 30
            static let buttonHeight: CGFloat = 54
            static let questionStackHeight: CGFloat = 44
            static let cornerRadius: CGFloat = 32
            static let buttonCornerRadius: CGFloat = 16
            static let questionButtonCornerRadius: CGFloat = 10
            static let iconSize: CGFloat = 20
        }
    }
    
    // MARK: - Properties

    private var questionButtons: [UIButton] = []
    private(set) var selectedQuestionCount: Int = Constants.defaultQuestionCount
    
    // MARK: - UI Elements
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var glassPanel: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.layer.cornerRadius = Constants.Layout.cornerRadius
        view.clipsToBounds = true
        return view
    }()

    private lazy var questionCountTitleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Quiz.TextInput.questionCount
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var questionCountStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.Layout.stackSpacing
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var retakeButton = makeButton(
        title: L10n.Quiz.Photo.Retake.button,
        systemImage: "arrow.counterclockwise",
        backgroundColor: .white.withAlphaComponent(0.1),
        hasBorder: true
    )
    
    lazy var continueButton = makeButton(
        title: L10n.Quiz.Question.continue,
        systemImage: "checkmark",
        backgroundColor: .clear
    )
    
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
        
        activityIndicator.isHidden = !isLoading
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        continueButton.isEnabled = !isLoading
        
        continueButton.layer.sublayers?
            .filter { $0 is CAGradientLayer }
            .forEach { $0.opacity = isLoading ? 0 : 1 }
        continueButton.backgroundColor = isLoading ? .white.withAlphaComponent(0.1) : .clear
        
        continueButton.configuration?.title = isLoading ? "" : L10n.Quiz.Question.continue
            continueButton.configuration?.image = isLoading ? nil : UIImage(systemName: "checkmark")
    }
}

// MARK: - Private Methods

private extension PhotoPreviewView {
    
    func setupUI() {
        backgroundColor = .black
        addSubviews(imageView, glassPanel)
        
        glassPanel.contentView.addSubviews(
            questionCountTitleLabel,
            questionCountStackView,
            retakeButton,
            continueButton
        )
        continueButton.addSubview(activityIndicator)
    }
    
    func makeButton(
        title: String,
        systemImage: String,
        backgroundColor: UIColor,
        hasBorder: Bool = false
    ) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.image = UIImage(systemName: systemImage)
        config.imagePadding = 8
        config.baseForegroundColor = .white
        config.background.cornerRadius = Constants.Layout.buttonCornerRadius
        config.background.backgroundColor = backgroundColor
        
        let button = UIButton(configuration: config)
        
        if hasBorder {
            button.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = Constants.Layout.buttonCornerRadius
        }
        
        return button
        
    }
    
    func createQuestionButton(with count: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("\(count)", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = Constants.Layout.questionButtonCornerRadius
        button.tag = count
        button.backgroundColor = .white.withAlphaComponent(0.1)
        button.setTitleColor(.white.withAlphaComponent(0.7), for: .normal)
        button.addTarget(self, action: #selector(questionCountTapped(_:)), for: .touchUpInside)
        return button
    }
    
    func setupQuestionButtons() {
        Constants.questionCounts.forEach { count in
            let button = createQuestionButton(with: count)
            questionButtons.append(button)
            questionCountStackView.addArrangedSubview(button)
        }
        selectedQuestionCount = Constants.defaultQuestionCount
        updateGradients()
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
        guard continueButton.bounds.width > 0 else { return }
        continueButton.applyGradient(colors: Constants.gradient, cornerRadius: Constants.Layout.buttonCornerRadius)
        
        questionButtons.forEach { button in
            
            button.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
            
            if button.tag == selectedQuestionCount {
                button.applyGradient(colors: Constants.gradient, cornerRadius: Constants.Layout.questionButtonCornerRadius)
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = .clear
            } else {
                button.backgroundColor = .white.withAlphaComponent(0.1)
                button.setTitleColor(.white.withAlphaComponent(0.7), for: .normal)
            }
        }
        
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        glassPanel.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(Constants.Layout.glassPanelBottom)
            $0.leading.trailing.equalToSuperview().inset(Constants.Layout.horizontalInset)
            $0.height.equalTo(Constants.Layout.glassPanelHeight)
        }

        questionCountTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.Layout.topOffset)
            $0.leading.equalToSuperview().offset(Constants.Layout.innerPadding)
        }
        
        questionCountStackView.snp.makeConstraints {
            $0.top.equalTo(questionCountTitleLabel.snp.bottom).offset(Constants.Layout.titleBottomOffset)
            $0.leading.trailing.equalToSuperview().inset(Constants.Layout.innerPadding)
            $0.height.equalTo(Constants.Layout.questionStackHeight)
        }
        
        retakeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(Constants.Layout.buttonBottomInset)
            $0.leading.equalToSuperview().offset(Constants.Layout.innerPadding)
            $0.height.equalTo(Constants.Layout.buttonHeight)
            $0.trailing.equalTo(self.snp.centerX).offset(-Constants.Layout.buttonSpacing)
        }
        
        continueButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(Constants.Layout.buttonBottomInset)
            $0.trailing.equalToSuperview().offset(-Constants.Layout.innerPadding)
            $0.height.equalTo(Constants.Layout.buttonHeight)
            $0.leading.equalTo(self.snp.centerX).offset(Constants.Layout.buttonSpacing)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
