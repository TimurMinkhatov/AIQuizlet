//
//  QuestionAnalysisCell.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 02.05.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

//
//  QuestionAnalysisCell.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 02.05.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

final class QuestionAnalysisCell: UITableViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        enum Layout {
            static let cornerRadius: CGFloat = 12
            static let borderWidth: CGFloat = 1
            static let defaultSpacing: CGFloat = 16
            static let smallSpacing: CGFloat = 12
            static let iconSize: CGFloat = 24
            static let chevronSize: CGFloat = 16
            static let optionHeight: CGFloat = 48
            static let mainContainerVerticalInset: CGFloat = 6
            static let explanationLabelInset: CGFloat = 12
            static let dividerHeight: CGFloat = 1
        }
        
        enum Animation {
            static let duration: TimeInterval = 0.3
        }
        
        enum Colors {
            static let chevron = UIColor.systemGray3
            static let divider = UIColor.systemGray6
            static let explanationBorder = UIColor(red: 43/255, green: 127/255, blue: 255/255, alpha: 0.3).cgColor
            static let explanationText = UIColor(red: 45/255, green: 65/255, blue: 85/255, alpha: 1)
        }
    }
    
    // MARK: - UI Elements
    
    private let mainContainer: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.historyCard
        view.layer.cornerRadius = Constants.Layout.cornerRadius
        view.layer.borderWidth = Constants.Layout.borderWidth
        view.layer.borderColor = AppColors.borderResult.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    private let headerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.Layout.smallSpacing
        stack.alignment = .center
        return stack
    }()
    
    private let statusIcon = UIImageView()
    
    private let questionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let rootStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.Layout.defaultSpacing
        return stack
    }()
    
    private let chevronIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        imageView.tintColor = Constants.Colors.chevron
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.divider
        view.isHidden = true
        return view
    }()
    
    private let detailsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.Layout.defaultSpacing
        stack.isHidden = true
        return stack
    }()
    
    private let fullQuestionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let optionsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private let explanationContainer: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.explanationBackground
        view.layer.cornerRadius = Constants.Layout.cornerRadius
        view.layer.borderWidth = Constants.Layout.borderWidth
        view.layer.borderColor = Constants.Colors.explanationBorder
        return view
    }()
    
    private let explanationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
    
    func configure(with question: QuestionRecord, userAnswerIndex: Int, index: Int, isExpanded: Bool) {
        let isCorrect = userAnswerIndex == question.correctAnswer
        
        configureHeader(index: index, isCorrect: isCorrect, isExpanded: isExpanded)
        
        if isExpanded {
            configureDetails(question: question, userAnswerIndex: userAnswerIndex, index: index)
        }
        
        updateConstraints(isExpanded: isExpanded)
    }
}

// MARK: - Private Methods

private extension QuestionAnalysisCell {
    
    func configureHeader(index: Int, isCorrect: Bool, isExpanded: Bool) {
        mainContainer.backgroundColor = isExpanded ? AppColors.detailedQuestion : AppColors.questionInResult
        questionTitleLabel.text = "\(L10n.Quiz.question) \(index + 1)"
        statusIcon.image = UIImage(systemName: isCorrect ? "checkmark.circle" : "xmark.circle")
        statusIcon.tintColor = isCorrect ? .systemGreen : .systemRed
        
        UIView.animate(withDuration: Constants.Animation.duration) {
            self.chevronIcon.transform = isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
        }
        
        dividerView.isHidden = !isExpanded
        detailsStack.isHidden = !isExpanded
    }
    
    func configureDetails(question: QuestionRecord, userAnswerIndex: Int, index: Int) {
        fullQuestionLabel.text = "\(L10n.Quiz.question) \(index + 1): \(question.text)"
        optionsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        question.answers.enumerated().forEach { answerIndex, text in
            let optionButton = QuizOptionButton()
            optionButton.title = text
            optionButton.isUserInteractionEnabled = false
            
            if answerIndex == question.correctAnswer {
                optionButton.updateState(.correct)
            } else if answerIndex == userAnswerIndex {
                optionButton.updateState(.wrong)
            } else {
                 optionButton.updateState(.normal)
            }
            
            optionsStack.addArrangedSubview(optionButton)
            optionButton.snp.makeConstraints { $0.height.equalTo(Constants.Layout.optionHeight) }
        }
        
        setupExplanation(question.explanation)
    }
    
    func setupExplanation(_ explanation: String?) {
        if let explanation = explanation, !explanation.isEmpty {
            explanationContainer.isHidden = false
            
            let attributedString = NSMutableAttributedString(string: L10n.Quiz.Explanation.title, attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .bold)
            ])
            attributedString.append(NSAttributedString(string: explanation, attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .regular)
            ]))
            
            explanationLabel.attributedText = attributedString
        } else {
            explanationContainer.isHidden = true
        }
    }
    
    func updateConstraints(isExpanded: Bool) {
        mainContainer.snp.remakeConstraints {
            $0.top.equalToSuperview().inset(Constants.Layout.mainContainerVerticalInset)
            $0.bottom.equalToSuperview().inset(Constants.Layout.mainContainerVerticalInset)
            $0.leading.trailing.equalToSuperview().inset(Constants.Layout.defaultSpacing)
            
            if isExpanded {
                $0.bottom.equalTo(detailsStack.snp.bottom).offset(Constants.Layout.defaultSpacing)
            } else {
                $0.bottom.equalTo(headerStack.snp.bottom).offset(Constants.Layout.defaultSpacing)
            }
        }
    }
    
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(mainContainer)
        mainContainer.addSubviews(rootStack, headerStack, dividerView, detailsStack)
        headerStack.addArrangedSubviews(statusIcon, questionTitleLabel, UIView(), chevronIcon)
        detailsStack.addArrangedSubviews(fullQuestionLabel, optionsStack, explanationContainer)
        explanationContainer.addSubview(explanationLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        mainContainer.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.Layout.mainContainerVerticalInset)
            $0.leading.trailing.equalToSuperview().inset(Constants.Layout.defaultSpacing)
        }
                
        headerStack.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(Constants.Layout.defaultSpacing)
            $0.height.equalTo(Constants.Layout.iconSize)
        }
        
        statusIcon.snp.makeConstraints {
            $0.size.equalTo(Constants.Layout.iconSize)
        }
        
        chevronIcon.snp.makeConstraints {
            $0.size.equalTo(Constants.Layout.chevronSize)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(headerStack.snp.bottom).offset(Constants.Layout.defaultSpacing)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.Layout.dividerHeight)
        }
        
        detailsStack.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(Constants.Layout.defaultSpacing)
            $0.leading.trailing.equalToSuperview().inset(Constants.Layout.defaultSpacing)
        }
        
        explanationLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constants.Layout.explanationLabelInset)
        }
    }
}
