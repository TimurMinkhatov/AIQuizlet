//
//  QuizViewController.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 07.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

final class QuizViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: QuizViewModel
    private let cardContentView = UIView()
    private let nextButtonGradient = CAGradientLayer()
    
    // MARK: - UI Elements
    
    private let progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.trackTintColor = .systemGray6
        return progress
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowRadius = 20
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        return view
    }()
    
    private let cardScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.alwaysBounceVertical = true
        return scroll
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let optionsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()
    
    private let explanationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.isHidden = true
        return view
    }()
    
    private let explanationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Объяснение:"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let explanationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let bulbIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "info.circle")
        iv.tintColor = .blue
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Далее", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
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
        
        view.addSubview(progressView)
        view.addSubview(progressLabel)
        view.addSubview(cardView)
        view.addSubview(nextButton)
        
        cardView.addSubview(cardScrollView)
        cardScrollView.addSubview(cardContentView)
        
        cardContentView.addSubview(questionLabel)
        cardContentView.addSubview(optionsStack)
        cardContentView.addSubview(explanationView)
        
        explanationView.addSubview(bulbIconImageView)
        explanationView.addSubview(explanationTitleLabel)
        explanationView.addSubview(explanationLabel)
        
        setupConstraints()
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    }
    
    func setupConstraints() {
        progressView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(4)
        }
        
        progressLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        
        cardView.snp.makeConstraints { make in
            make.top.equalTo(progressLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(nextButton.snp.top).offset(-20)
        }
        
        cardScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cardContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        questionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        optionsStack.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        explanationView.snp.makeConstraints { make in
            make.top.equalTo(optionsStack.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(24)
        }
        
        bulbIconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(20)
        }
        
        explanationTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bulbIconImageView)
            make.leading.equalTo(bulbIconImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(16)
        }
        
        explanationLabel.snp.makeConstraints { make in
            make.top.equalTo(explanationTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(explanationTitleLabel.snp.leading)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
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
                case .finished(let score, let total):
                    print("Финиш: \(score)/\(total)")
                case .idle: break
                }
            }
        }
    }
    
    func getGradientImage(bounds: CGRect) -> UIImage? {
        guard bounds.width > 0 else { return nil }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor(red: 21/255, green: 93/255, blue: 252/255, alpha: 1).cgColor,
            UIColor(red: 152/255, green: 16/255, blue: 250/255, alpha: 1).cgColor,
            UIColor(red: 130/255, green: 0/255, blue: 219/255, alpha: 1).cgColor
        ]
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
        progressLabel.text = "Вопрос \(current) из \(total)"
        let progress = Float(current) / Float(total)
        progressView.setProgress(progress, animated: true)
    }
    
    func render(question: Question, number: Int) {
        questionLabel.text = "Вопрос \(number): \(question.text)"
        optionsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let prefixes = ["A", "B", "C", "D"]
        
        question.answers.enumerated().forEach { index, answerText in
            let button = QuizOptionButton()
            button.title = "Вариант \(prefixes[index % 4]) — \(answerText)"
            button.tag = index
            button.addTarget(self, action: #selector(optionTapped(_:)), for: .touchUpInside)
            optionsStack.addArrangedSubview(button)
            button.snp.makeConstraints { make in make.height.equalTo(60) }
        }
        cardScrollView.setContentOffset(.zero, animated: false)
    }
    
    func showResultUI(correctIndex: Int, question: Question) {
        optionsStack.arrangedSubviews.enumerated().forEach { index, view in
            guard let button = view as? QuizOptionButton else { return }
            button.isUserInteractionEnabled = false
            button.updateState(isCorrect: index == correctIndex)
        }
        
        explanationLabel.text = question.explanation ?? "Правильный ответ на основе предоставленного текста."
        explanationView.isHidden = false
        nextButton.isHidden = false
        
        view.layoutIfNeeded()
        let bottomOffset = CGPoint(x: 0, y: max(0, cardScrollView.contentSize.height - cardScrollView.bounds.size.height))
        cardScrollView.setContentOffset(bottomOffset, animated: true)
        updateNextButtonGradient()
    }
    
    func resetUI() {
        explanationView.isHidden = true
        nextButton.isHidden = true
        optionsStack.arrangedSubviews.forEach { $0.isUserInteractionEnabled = true }
    }
    
    func updateNextButtonGradient() {
        nextButtonGradient.colors = [
            UIColor(red: 21/255, green: 93/255, blue: 252/255, alpha: 1).cgColor,
            UIColor(red: 152/255, green: 16/255, blue: 250/255, alpha: 1).cgColor,
            UIColor(red: 130/255, green: 0/255, blue: 219/255, alpha: 1).cgColor
        ]
        nextButtonGradient.startPoint = CGPoint(x: 0, y: 0.5)
        nextButtonGradient.endPoint = CGPoint(x: 1, y: 0.5)
        nextButtonGradient.frame = nextButton.bounds
        nextButtonGradient.cornerRadius = 16
        
        if nextButtonGradient.superlayer == nil {
            nextButton.layer.insertSublayer(nextButtonGradient, at: 0)
        }
    }
}
