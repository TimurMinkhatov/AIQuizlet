//
//  TextInputViewController.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 13/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - Constants

private extension TextInputViewController {
    enum Constants {
        // Числовые параметры логики
        static let maxCharacters: Int = 5000
        static let minCharacters: Int = 50
        static let questionCounts: [Int] = [5, 10, 15, 20]
        
        // Параметры верстки (Layout)
        enum Layout {
            static let textViewCornerRadius: CGFloat = 12
            static let buttonCornerRadius: CGFloat = 12
            static let questionButtonCornerRadius: CGFloat = 10
            static let textViewHeight: CGFloat = 220
            static let bottomButtonHeight: CGFloat = 50
            static let questionButtonHeight: CGFloat = 44
            
            static let standardInset: CGFloat = 16
            static let elementSpacing: CGFloat = 24
            static let smallSpacing: CGFloat = 12
            static let textViewInternalInset: CGFloat = 4
            static let placeholderTopOffset: CGFloat = 12
            static let placeholderSideInset: CGFloat = 8
            static let borderWidth: CGFloat = 1.5
        }
        
        // Цвета
        enum Colors {
            static let gradient = [
                UIColor(red: 21/255, green: 93/255, blue: 252/255, alpha: 1),
                UIColor(red: 152/255, green: 16/255, blue: 250/255, alpha: 1)
            ]
            static let border = UIColor.systemBlue
            static let background = UIColor.systemGroupedBackground
            static let inactiveButton = UIColor.systemGray3
        }
        
        // Системные иконки
        enum Images {
            static let sparkles = UIImage(systemName: "sparkles")
            static let clipboard = UIImage(systemName: "clipboard")
        }

        // Строки
        enum Strings {
            static let title = "Ввод текста"
            static let textViewPlaceholder = "Напишите текст конспекта..."
            static let textViewSubPlaceholder = "Минимальная длина конспекта 50 символов"
            static let questionCountTitle = "Количество вопросов"
            static let pasteButton = "Вставить"
            static let generateButton = "Сгенерировать тест"
            static let generating = "Генерация..."
            static let errorTitle = "Ошибка"
            static let errorAction = "OK"
            static let characterCount = "%d / %d символов"
        }
    }
}

// MARK: - TextInputViewController

final class TextInputViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: TextInputViewModel
    private var questionButtons: [UIButton] = []

    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }()

    private lazy var contentView = UIView()

    private lazy var textContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.Layout.textViewCornerRadius
        view.layer.borderWidth = Constants.Layout.borderWidth
        view.layer.borderColor = Constants.Colors.border.cgColor
        return view
    }()

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 15)
        textView.textColor = .label
        textView.backgroundColor = .clear
        textView.delegate = self
        return textView
    }()

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = false

        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 6

        let attributed = NSMutableAttributedString(
            string: Constants.Strings.textViewPlaceholder + "\n",
            attributes: [
                .font: UIFont.systemFont(ofSize: 15),
                .foregroundColor: UIColor.placeholderText,
                .paragraphStyle: paragraph
            ]
        )
        attributed.append(NSAttributedString(
            string: Constants.Strings.textViewSubPlaceholder,
            attributes: [
                .font: UIFont.systemFont(ofSize: 13),
                .foregroundColor: UIColor.placeholderText,
                .paragraphStyle: paragraph
            ]
        ))
        label.attributedText = attributed
        return label
    }()

    private lazy var questionCountTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Strings.questionCountTitle
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    private lazy var questionCountStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var characterCountLabel: UILabel = {
        let label = UILabel()
        label.text = String(format: Constants.Strings.characterCount, 0, Constants.maxCharacters)
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var pasteButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        config.title = Constants.Strings.pasteButton
        config.image = Constants.Images.clipboard
        config.imagePadding = 8
        config.baseForegroundColor = .label
        config.background.cornerRadius = Constants.Layout.buttonCornerRadius
        config.background.strokeColor = .systemGray4
        config.background.strokeWidth = 1
        config.background.backgroundColor = .clear
        return UIButton(configuration: config)
    }()

    private lazy var generateButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = Constants.Strings.generateButton
        config.image = Constants.Images.sparkles
        config.imagePadding = 8
        config.baseForegroundColor = .white
        config.background.cornerRadius = Constants.Layout.buttonCornerRadius
        config.background.backgroundColor = Constants.Colors.inactiveButton
        let button = UIButton(configuration: config)
        button.isEnabled = false
        return button
    }()

    private lazy var bottomStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()

    // MARK: - Init
    init(viewModel: TextInputViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupQuestionButtons()
        setupActions()
        bindViewModel()
        hideKeyboardWhenTappedAround()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateGradients()
    }
}

// MARK: - UITextViewDelegate
extension TextInputViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateTextInput(with: textView.text ?? "")
    }
}

// MARK: - Actions
private extension TextInputViewController {
    @objc func questionCountTapped(_ sender: UIButton) {
        questionButtons.forEach {
            $0.backgroundColor = .white
            $0.setTitleColor(.label, for: .normal)
        }
        viewModel.update(questionCount: sender.tag)
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

    @objc func pasteTapped() {
        if let string = UIPasteboard.general.string {
            textView.text = string
            updateTextInput(with: string)
        }
    }

    @objc func generateTapped() {
        viewModel.generateQuiz()
    }
}

// MARK: - Setup Logic
private extension TextInputViewController {
    func setupLayout() {
        title = Constants.Strings.title
        view.backgroundColor = Constants.Colors.background
        navigationController?.navigationBar.tintColor = .black

        view.addSubviews(scrollView, bottomStackView)
        scrollView.addSubview(contentView)
        textContainerView.addSubviews(textView, placeholderLabel)
        contentView.addSubviews(textContainerView, questionCountTitleLabel, questionCountStackView, characterCountLabel)
        bottomStackView.addArrangedSubview(pasteButton)
        bottomStackView.addArrangedSubview(generateButton)

        setupConstraints()
    }

    func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomStackView.snp.top).offset(-Constants.Layout.smallSpacing)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        textContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.Layout.standardInset)
            $0.leading.trailing.equalToSuperview().inset(Constants.Layout.standardInset)
        }

        placeholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.Layout.placeholderTopOffset)
            $0.leading.trailing.equalToSuperview().inset(Constants.Layout.placeholderSideInset)
        }

        textView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constants.Layout.textViewInternalInset)
            $0.height.greaterThanOrEqualTo(Constants.Layout.textViewHeight)
        }

        questionCountTitleLabel.snp.makeConstraints {
            $0.top.equalTo(textContainerView.snp.bottom).offset(Constants.Layout.elementSpacing)
            $0.leading.trailing.equalToSuperview().inset(Constants.Layout.standardInset)
        }

        questionCountStackView.snp.makeConstraints {
            $0.top.equalTo(questionCountTitleLabel.snp.bottom).offset(Constants.Layout.smallSpacing)
            $0.leading.trailing.equalToSuperview().inset(Constants.Layout.standardInset)
            $0.height.equalTo(Constants.Layout.questionButtonHeight)
        }

        characterCountLabel.snp.makeConstraints {
            $0.top.equalTo(questionCountStackView.snp.bottom).offset(Constants.Layout.smallSpacing)
            $0.leading.equalToSuperview().inset(Constants.Layout.standardInset)
            $0.bottom.equalToSuperview().inset(Constants.Layout.standardInset)
        }

        bottomStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.Layout.standardInset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.Layout.standardInset)
            $0.height.equalTo(Constants.Layout.bottomButtonHeight)
        }
    }

    func setupQuestionButtons() {
        Constants.questionCounts.enumerated().forEach { index, count in
            let button = UIButton()
            button.setTitle("\(count)", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            button.layer.cornerRadius = Constants.Layout.questionButtonCornerRadius
            button.tag = count
            button.addTarget(self, action: #selector(questionCountTapped(_:)), for: .touchUpInside)

            if index == 0 {
                button.backgroundColor = .systemIndigo
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = .white
                button.setTitleColor(.label, for: .normal)
            }

            questionButtons.append(button)
            questionCountStackView.addArrangedSubview(button)
        }
    }

    func setupActions() {
        pasteButton.addTarget(self, action: #selector(pasteTapped), for: .touchUpInside)
        generateButton.addTarget(self, action: #selector(generateTapped), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch state {
                case .loading:
                    self.generateButton.isEnabled = false
                    self.generateButton.configuration?.showsActivityIndicator = true
                    self.generateButton.configuration?.title = Constants.Strings.generating
                case .idle:
                    self.generateButton.isEnabled = false
                    self.generateButton.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
                    self.generateButton.configuration?.showsActivityIndicator = false
                    self.generateButton.configuration?.title = Constants.Strings.generateButton
                case .error(let message):
                    self.generateButton.isEnabled = true
                    self.generateButton.configuration?.showsActivityIndicator = false
                    self.generateButton.configuration?.title = Constants.Strings.generateButton
                    self.showError(message: message)
                }
            }
        }
    }

    func updateGradients() {
        if generateButton.isEnabled {
            generateButton.configuration?.background.backgroundColor = .clear
            generateButton.applyGradient(colors: Constants.Colors.gradient, cornerRadius: Constants.Layout.buttonCornerRadius)
        } else {
            generateButton.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
            generateButton.configuration?.background.backgroundColor = Constants.Colors.inactiveButton
        }
        
        questionButtons.forEach { button in
            button.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
            
            if button.tag == viewModel.questionCount {
                button.applyGradient(colors: Constants.Colors.gradient, cornerRadius: Constants.Layout.questionButtonCornerRadius)
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = .white
                button.setTitleColor(.label, for: .normal)
            }
        }
    }

    func updateTextInput(with text: String) {
        let count = text.count
        placeholderLabel.isHidden = !text.isEmpty
        characterCountLabel.text = String(format: Constants.Strings.characterCount, count, Constants.maxCharacters)
        generateButton.isEnabled = count >= Constants.minCharacters && count <= Constants.maxCharacters
        view.setNeedsLayout()
        view.layoutIfNeeded()
        if count > Constants.maxCharacters {
            textView.text = String(text.prefix(Constants.maxCharacters))
        }
        viewModel.update(text: textView.text)
    }
    
    func showError(message: String) {
        guard presentedViewController == nil else { return }
        let alert = UIAlertController(title: Constants.Strings.errorTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.Strings.errorAction, style: .default))
        present(alert, animated: true)
    }
}
