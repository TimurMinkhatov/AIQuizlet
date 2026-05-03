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

import UIKit
import SnapKit

final class QuestionAnalysisCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    private let mainContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    private let headerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        return stack
    }()
    
    private let statusIcon = UIImageView()
    
    private let questionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private let rootStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    private let chevronIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.down"))
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.isHidden = true
        return view
    }()
    
    private let detailsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.isHidden = true
        return stack
    }()
    
    private let fullQuestionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black
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
        view.backgroundColor = UIColor(red: 235/255, green: 243/255, blue: 255/255, alpha: 1)
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 215/255, green: 230/255, blue: 250/255, alpha: 1).cgColor
        return view
    }()
    
    private let explanationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(red: 45/255, green: 65/255, blue: 85/255, alpha: 1)
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
    
    func configure(with question: QuestionRecord, index: Int, isExpanded: Bool) {
        questionTitleLabel.text = "Вопрос \(index + 1)"
        
        let isCorrect = question.userAnswerIndex == question.correctAnswer
        statusIcon.image = UIImage(systemName: isCorrect ? "checkmark.circle" : "xmark.circle")
        statusIcon.tintColor = isCorrect ? .systemGreen : .systemRed
        
        UIView.animate(withDuration: 0.3) {
            self.chevronIcon.transform = isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
        }
        
        dividerView.isHidden = !isExpanded
        detailsStack.isHidden = !isExpanded
        
        if isExpanded {
            fullQuestionLabel.text = "Вопрос \(index + 1): \(question.text)"
            
            optionsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            question.answers.enumerated().forEach { answerIndex, text in
                let optionButton = QuizOptionButton()
                optionButton.title = text
                optionButton.isUserInteractionEnabled = false
                
                if answerIndex == question.correctAnswer {
                    optionButton.updateState(.correct)
                } else if answerIndex == question.userAnswerIndex {
                    optionButton.updateState(.wrong)
                } else {
                     optionButton.updateState(.normal)
                }
                
                optionsStack.addArrangedSubview(optionButton)
                optionButton.snp.makeConstraints { $0.height.equalTo(48) }
            }
            
            if let explanation = question.explanation, !explanation.isEmpty {
                explanationContainer.isHidden = false
                
                let boldText = "Объяснение: "
                let normalText = explanation
                
                let attributedString = NSMutableAttributedString(string: boldText, attributes: [
                    .font: UIFont.systemFont(ofSize: 14, weight: .bold)
                ])
                attributedString.append(NSAttributedString(string: normalText, attributes: [
                    .font: UIFont.systemFont(ofSize: 14, weight: .regular)
                ]))
                
                explanationLabel.attributedText = attributedString
            } else {
                explanationContainer.isHidden = true
            }
        }
        
        mainContainer.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(6)
                $0.bottom.equalToSuperview().inset(6)
                $0.leading.trailing.equalToSuperview().inset(16)
                
                if isExpanded {
                    $0.bottom.equalTo(detailsStack.snp.bottom).offset(16)
                } else {
                    $0.bottom.equalTo(headerStack.snp.bottom).offset(16)
                }
            }
    }
}

// MARK: - Setup

private extension QuestionAnalysisCell {
    
    
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
            $0.top.bottom.equalToSuperview().inset(6)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
                
        headerStack.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(24)
        }
        
        statusIcon.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        chevronIcon.snp.makeConstraints {
            $0.size.equalTo(16)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(headerStack.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        detailsStack.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        explanationLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
    }
}
