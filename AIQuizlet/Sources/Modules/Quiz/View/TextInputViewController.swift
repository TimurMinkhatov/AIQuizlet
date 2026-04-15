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
        static let textViewCornerRadius: CGFloat = 12
        static let buttonCornerRadius: CGFloat = 12
        static let questionButtonCornerRadius: CGFloat = 10
        static let textViewHeight: CGFloat = 220
        static let bottomButtonHeight: CGFloat = 50
        static let questionButtonHeight: CGFloat = 44
        static let maxCharacters: Int = 5000
        static let questionCounts: [Int] = [5, 10, 15, 20]

        enum Strings {
            static let title = "Ввод текста"
            static let textViewPlaceholder = "Напишите текст конспекта..."
            static let textViewSubPlaceholder = "Минимальная длина конспекта 50 символов"
            static let questionCountTitle = "Количество вопросов"
            static let pasteButton = "Вставить"
            static let generateButton = "Сгенерировать тест"
            static let errorTitle = "Ошибка"
            static let errorAction = "OK"
        }
    }
}

// MARK: - TextInputViewController

final class TextInputViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: TextInputViewModel

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
        view.layer.cornerRadius = Constants.textViewCornerRadius
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.systemBlue.cgColor
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
        label.text = "0 / \(Constants.maxCharacters) символов"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var pasteButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        config.title = Constants.Strings.pasteButton
        config.imagePadding = 8
        config.baseForegroundColor = .label
        config.background.cornerRadius = Constants.buttonCornerRadius
        config.background.strokeColor = .systemGray4
        config.background.strokeWidth = 1
        config.background.backgroundColor = .clear
        return UIButton(configuration: config)
    }()

    private lazy var generateButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = Constants.Strings.generateButton
        config.image = UIImage(systemName: "sparkles")
        config.imagePadding = 8
        config.baseForegroundColor = .white
        config.background.cornerRadius = Constants.buttonCornerRadius
        config.background.backgroundColor = .systemGray3
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

    private var questionButtons: [UIButton] = []

    // MARK: - Init

    init(viewModel: TextInputViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Инициализатор не реализован")
    }
}

// MARK: - Lifecycle

extension TextInputViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupQuestionButtons()
        setupActions()
        bindViewModel()
    }
}

// MARK: - UITextViewDelegate

extension TextInputViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        updateTextInput(with: textView.text ?? "")
    }
}

// MARK: - Private Methods

private extension TextInputViewController {

    func setupLayout() {
        title = Constants.Strings.title
        view.backgroundColor = UIColor.systemGroupedBackground

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        textContainerView.addSubview(textView)
        textContainerView.addSubview(placeholderLabel)

        contentView.addSubview(textContainerView)
        contentView.addSubview(questionCountTitleLabel)
        contentView.addSubview(questionCountStackView)
        contentView.addSubview(characterCountLabel)

        bottomStackView.addArrangedSubview(pasteButton)
        bottomStackView.addArrangedSubview(generateButton)
        view.addSubview(bottomStackView)

        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomStackView.snp.top).offset(-12)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        textContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        placeholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.trailing.equalToSuperview().inset(8)
        }

        textView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
            $0.height.greaterThanOrEqualTo(Constants.textViewHeight)
        }

        questionCountTitleLabel.snp.makeConstraints {
            $0.top.equalTo(textContainerView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        questionCountStackView.snp.makeConstraints {
            $0.top.equalTo(questionCountTitleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(Constants.questionButtonHeight)
        }

        characterCountLabel.snp.makeConstraints {
            $0.top.equalTo(questionCountStackView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }

        bottomStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(Constants.bottomButtonHeight)
        }
    }

    func setupQuestionButtons() {
        Constants.questionCounts.enumerated().forEach { index, count in
            let button = UIButton()
            button.setTitle("\(count)", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            button.layer.cornerRadius = Constants.questionButtonCornerRadius
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
            guard let self else { return }
            switch state {
            case .success(let quiz):
                self.viewModel.coordinator?.didGenerateQuiz(quiz)
            case .error(let message):
                self.showError(message: message)
            default:
                break
            }
        }
    }

    func updateTextInput(with text: String) {
        let count = text.count

        placeholderLabel.isHidden = !text.isEmpty
        characterCountLabel.text = "\(count) / \(Constants.maxCharacters) символов"

        let isValid = count >= 50 && count <= Constants.maxCharacters
        generateButton.isEnabled = isValid
        var config = generateButton.configuration
        config?.background.backgroundColor = isValid ? .systemIndigo : .systemGray3
        generateButton.configuration = config

        if count > Constants.maxCharacters {
            textView.text = String(text.prefix(Constants.maxCharacters))
        }

        viewModel.update(text: textView.text)
    }

    func showError(message: String) {
        let alert = UIAlertController(
            title: Constants.Strings.errorTitle,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: Constants.Strings.errorAction, style: .default))
        present(alert, animated: true)
    }

    @objc func questionCountTapped(_ sender: UIButton) {
        questionButtons.forEach {
            $0.backgroundColor = .white
            $0.setTitleColor(.label, for: .normal)
        }
        sender.backgroundColor = .systemIndigo
        sender.setTitleColor(.white, for: .normal)
        viewModel.update(questionCount: sender.tag)
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
