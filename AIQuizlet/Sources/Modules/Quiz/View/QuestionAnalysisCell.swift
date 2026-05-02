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
    
    // MARK: - UI Elements
    
    private lazy var containerStack = UIStackView()
    private lazy var headerStack = UIStackView()
    private lazy var detailsStack = UIStackView()
    
    private lazy var questionLabel = UILabel()
    private lazy var explanationLabel = UILabel()
    private lazy var statusIcon = UIImageView()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerStack)
        containerStack.axis = .vertical
        containerStack.spacing = 12
        
        containerStack.addArrangedSubview(headerStack)
        headerStack.axis = .horizontal
        headerStack.spacing = 12
        headerStack.alignment = .center
        
        headerStack.addArrangedSubview(statusIcon)
        headerStack.addArrangedSubview(questionLabel)
        
        containerStack.addArrangedSubview(detailsStack)
        detailsStack.axis = .vertical
        detailsStack.spacing = 8
        detailsStack.addArrangedSubview(explanationLabel)
        
        containerStack.snp.makeConstraints { $0.edges.equalToSuperview().inset(16) }
        statusIcon.snp.makeConstraints { $0.size.equalTo(24) }
        
        questionLabel.numberOfLines = 0
        explanationLabel.numberOfLines = 0
        explanationLabel.font = .systemFont(ofSize: 14)
        explanationLabel.textColor = .lightGray
    }

    func configure(with question: QuestionRecord, isExpanded: Bool) {
        questionLabel.text = question.text
        explanationLabel.text = question.explanation ?? "Правильный ответ на основе предоставленного текста."
        
        let isCorrect = question.userAnswerIndex == question.correctAnswer
        statusIcon.image = UIImage(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
        statusIcon.tintColor = isCorrect ? .systemGreen : .systemRed
        
        detailsStack.isHidden = !isExpanded
        
        detailsStack.arrangedSubviews.filter { $0 is QuizOptionButton }.forEach { $0.removeFromSuperview() }
        
        question.answers.enumerated().forEach { index, text in
            let optionButton = QuizOptionButton()
            optionButton.title = text
            optionButton.isUserInteractionEnabled = false
            
            if index == question.correctAnswer {
                optionButton.updateState(.correct)
            } else if index == question.userAnswerIndex {
                optionButton.updateState(.wrong)
            }
            
            detailsStack.insertArrangedSubview(optionButton, at: 0)
            optionButton.snp.makeConstraints { $0.height.equalTo(44) }
        }
    }
}
