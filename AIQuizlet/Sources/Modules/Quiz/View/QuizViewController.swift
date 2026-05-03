//
//  QuizViewController.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 07.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit


// MARK: - Constants

private extension QuizViewController {
    enum Constants {
        
        enum Layout {
            static let cardCornerRadius: CGFloat = 24
            static let buttonCornerRadius: CGFloat = 16
            static let explanationCornerRadius: CGFloat = 12
            static let progressHeight: CGFloat = 4
            static let nextButtonHeight: CGFloat = 56
            static let optionButtonHeight: CGFloat = 60
            static let shadowRadius: CGFloat = 20
            static let shadowOpacity: Float = 0.05
            
            static let standardInset: CGFloat = 24
            static let sidePadding: CGFloat = 20
            static let verticalSpacing: CGFloat = 24
            static let smallSpacing: CGFloat = 10
            static let innerPadding: CGFloat = 16
            static let selectedBorderWidth: CGFloat = 2.5
        }
        
        enum Colors {
            static let gradient = [
                UIColor(red: 21/255, green: 93/255, blue: 252/255, alpha: 1),
                UIColor(red: 152/255, green: 16/255, blue: 250/255, alpha: 1),
                UIColor(red: 130/255, green: 0/255, blue: 219/255, alpha: 1)
            ]
            static let shadow = UIColor.black
            static let trackTint = UIColor.systemGray6
            static let infoIcon = UIColor.blue
        }
        
        enum Strings {
            static let explanationTitle = "Объяснение:"
            static let nextButtonTitle = "Далее"
            static let progressFormat = "Вопрос %d из %d"
            static let defaultExplanation = "Правильный ответ на основе предоставленного текста."
            static let optionPrefixes = ["A", "B", "C", "D"]
            static let optionTitleFormat = "Вариант %@ — %@"
        }
    }
}

// MARK: - QuizViewController

final class QuizViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: QuizViewModel
    private let cardContentView = UIView()
    private let nextButtonGradient = CAGradientLayer()
    private var selectedOptionIndex: Int?
    
    // MARK: - UI Elements
    private lazy var progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.trackTintColor = Constants.Colors.trackTint
        return progress
    }()
    
    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.Layout.cardCornerRadius
        view.layer.shadowColor = Constants.Colors.shadow.cgColor
        view.layer.shadowOpacity = Constants.Layout.shadowOpacity
        view.layer.shadowRadius = Constants.Layout.shadowRadius
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        return view
    }()
    
    private lazy var cardScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.alwaysBounceVertical = true
        return scroll
    }()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var optionsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()
    
    private lazy var explanationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.Layout.explanationCornerRadius
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.isHidden = true
        return view
    }()
    
    private lazy var explanationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Strings.explanationTitle
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var explanationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var bulbIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "info.circle")
        iv.tintColor = Constants.Colors.infoIcon
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.Strings.nextButtonTitle, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.Layout.buttonCornerRadius
        button.isHidden = true
        return button
    }()
    
    // MARK: - Init
    init(viewModel: QuizViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !nextButton.isHidden {
            updateNextButtonGradient()
        }
        if let gradientImage = getGradientImage(bounds: progressView.bounds) {
            progressView.progressImage = gradientImage
        }
    }
}

// MARK: - Actions
private extension QuizViewController {
    @objc func optionTapped(_ sender: QuizOptionButton) {
        selectedOptionIndex = sender.tag
        optionsStack.arrangedSubviews.forEach {
            ($0 as? QuizOptionButton)?.updateState(.normal)
        }
        sender.updateState(.selected)
        viewModel.selectAnswer(index: sender.tag)
    }
    
    @objc func nextTapped() {
        viewModel.nextQuestion()
    }
}

// MARK: - Setup Logic
private extension QuizViewController {
    func setupUI() {
        view.backgroundColor = .white
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = .black
        
        view.addSubviews(progressView, progressLabel, cardView, nextButton)
        cardView.addSubview(cardScrollView)
        cardScrollView.addSubview(cardContentView)
        cardContentView.addSubviews(questionLabel, optionsStack, explanationView)
        explanationView.addSubviews(bulbIconImageView, explanationTitleLabel, explanationLabel)
        
        setupConstraints()
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    }
    
    func setupConstraints() {
        progressView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.Layout.progressHeight)
        }
        
        progressLabel.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom).offset(Constants.Layout.smallSpacing)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.trailing.equalToSuperview().inset(Constants.Layout.standardInset)
            $0.height.equalTo(Constants.Layout.nextButtonHeight)
        }
        
        cardView.snp.makeConstraints {
            $0.top.equalTo(progressLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(Constants.Layout.standardInset)
            $0.bottom.equalTo(nextButton.snp.top).offset(-20)
        }
        
        cardScrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        cardContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        questionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.Layout.standardInset)
            $0.leading.trailing.equalToSuperview().inset(Constants.Layout.sidePadding)
        }
        
        optionsStack.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(Constants.Layout.verticalSpacing)
            $0.leading.trailing.equalToSuperview().inset(Constants.Layout.sidePadding)
        }
        
        explanationView.snp.makeConstraints {
            $0.top.equalTo(optionsStack.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(Constants.Layout.sidePadding)
            $0.bottom.equalToSuperview().inset(Constants.Layout.standardInset)
        }
        
        bulbIconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.Layout.innerPadding)
            $0.leading.equalToSuperview().offset(Constants.Layout.innerPadding)
            $0.size.equalTo(20)
        }
        
        explanationTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(bulbIconImageView)
            $0.leading.equalTo(bulbIconImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(Constants.Layout.innerPadding)
        }
        
        explanationLabel.snp.makeConstraints {
            $0.top.equalTo(explanationTitleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(explanationTitleLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(Constants.Layout.innerPadding)
            $0.bottom.equalToSuperview().inset(Constants.Layout.innerPadding)
        }
    }
}

// MARK: - Private Methods
private extension QuizViewController {
    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch state {
                case .showingQuestion(let question, let current, let total):
                    self.resetUI()
                    self.updateProgress(current: current, total: total)
                    self.render(question: question, number: current)
                case .showingResult(_, let correctIndex, let question):
                    self.showResultUI(correctIndex: correctIndex, question: question)
                case .finished(_, _):
                    break
                case .idle: break
                }
            }
        }
    }
    
    func getGradientImage(bounds: CGRect) -> UIImage? {
        guard bounds.width > 0 else { return nil }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = Constants.Colors.gradient.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }
    
    func updateProgress(current: Int, total: Int) {
        progressLabel.text = String(format: Constants.Strings.progressFormat, current, total)
        let progress = Float(current) / Float(total)
        progressView.setProgress(progress, animated: true)
    }
    
    func render(question: Question, number: Int) {
        questionLabel.text = "Вопрос \(number): \(question.text)"
        optionsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        question.answers.enumerated().forEach { index, answerText in
            let button = QuizOptionButton()
            let prefix = Constants.Strings.optionPrefixes[index % 4]
            button.title = String(format: Constants.Strings.optionTitleFormat, prefix, answerText)
            button.tag = index
            button.addTarget(self, action: #selector(optionTapped(_:)), for: .touchUpInside)
            optionsStack.addArrangedSubview(button)
            button.snp.makeConstraints { make in make.height.equalTo(Constants.Layout.optionButtonHeight) }
        }
        cardScrollView.setContentOffset(.zero, animated: false)
    }
    
    func showResultUI(correctIndex: Int, question: Question) {
        optionsStack.arrangedSubviews.enumerated().forEach { index, view in
            guard let button = view as? QuizOptionButton else { return }
            button.isUserInteractionEnabled = false
            let resultState: QuizOptionButton.State = (index == correctIndex) ? .correct : .wrong
            button.updateState(resultState)
            
            if index == selectedOptionIndex {
                button.layer.borderWidth = Constants.Layout.selectedBorderWidth
            }
        }
        
        explanationLabel.text = question.explanation ?? Constants.Strings.defaultExplanation
        explanationView.isHidden = false
        nextButton.isHidden = false
        
        view.layoutIfNeeded()
        let bottomOffset = CGPoint(x: 0, y: max(0, cardScrollView.contentSize.height - cardScrollView.bounds.size.height))
        cardScrollView.setContentOffset(bottomOffset, animated: true)
        updateNextButtonGradient()
    }
    
    func resetUI() {
        selectedOptionIndex = nil
        explanationView.isHidden = true
        nextButton.isHidden = true
        optionsStack.arrangedSubviews.forEach { $0.isUserInteractionEnabled = true }
    }
    
    func updateNextButtonGradient() {
        nextButton.applyGradient(colors: Array(Constants.Colors.gradient.prefix(2)), cornerRadius: Constants.Layout.buttonCornerRadius)
    }
}
