//
//  AuthViewController.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 07/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - Constants

private extension AuthViewController {
    enum Constants {
        static let cardCornerRadius: CGFloat = 20
        static let iconCornerRadius: CGFloat = 40
        static let buttonCornerRadius: CGFloat = 12
        static let cardHorizontalInset: CGFloat = 20
        static let cardVerticalInset: CGFloat = 60
        static let iconSize: CGFloat = 80
        static let iconImageSize: CGFloat = 40
        static let textFieldHeight: CGFloat = 50
        static let buttonHeight: CGFloat = 50
        static let fieldSpacing: CGFloat = 8

        enum Strings {
            static let loginTitle = "Добро пожаловать!"
            static let loginSubtitle = "Войдите в свой аккаунт"
            static let loginPasswordPlaceholder = "······"
            static let loginAction = "Войти"
            static let loginSwitch = "Нет аккаунта? Зарегистрироваться"

            static let registerTitle = "Создать аккаунт"
            static let registerSubtitle = "Зарегистрируйтесь для начала работы"
            static let registerPasswordPlaceholder = "Минимум 6 символов"
            static let registerAction = "Зарегистрироваться"
            static let registerSwitch = "Уже есть аккаунт? Войти"

            static let emailLabel = "Email"
            static let emailPlaceholder = "example@email.com"
            static let passwordLabel = "Пароль"
            static let confirmPasswordLabel = "Подтвердите пароль"
            static let confirmPasswordPlaceholder = "Повторите пароль"
            static let errorTitle = "Ошибка"
            static let errorAction = "OK"
        }
    }
}

// MARK: - AuthViewController

final class AuthViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: AuthViewModel

    private var state: AuthState = .login {
        didSet { updateUI() }
    }

    // MARK: - UI Components

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .onDrag
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private let contentView = UIView()

    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(red: 0.2, green: 0.4, blue: 1.0, alpha: 1.0).cgColor,
            UIColor(red: 0.5, green: 0.2, blue: 0.9, alpha: 1.0).cgColor
        ]
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        return layer
    }()

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.cardCornerRadius
        return view
    }()

    private let iconContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.9, green: 0.93, blue: 1.0, alpha: 1.0)
        view.layer.cornerRadius = Constants.iconCornerRadius
        return view
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "book")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()

    private let actionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        return button
    }()

    private let switchButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()

    private let emailTextField: UITextField
    private let passwordTextField: UITextField
    private let confirmPasswordTextField: UITextField

    private let emailStack: UIStackView
    private let passwordStack: UIStackView
    private let confirmPasswordStack: UIStackView

    // MARK: - Init

    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel

        let emailField = AuthViewController.makeFieldStack(
            labelText: Constants.Strings.emailLabel,
            placeholder: Constants.Strings.emailPlaceholder,
            keyboardType: .emailAddress,
            iconName: "envelope"
        )
        let passwordField = AuthViewController.makeFieldStack(
            labelText: Constants.Strings.passwordLabel,
            placeholder: Constants.Strings.loginPasswordPlaceholder,
            isSecure: true,
            iconName: "lock"
        )
        let confirmPasswordField = AuthViewController.makeFieldStack(
            labelText: Constants.Strings.confirmPasswordLabel,
            placeholder: Constants.Strings.confirmPasswordPlaceholder,
            isSecure: true,
            iconName: "lock"
        )

        emailTextField = emailField.textField
        passwordTextField = passwordField.textField
        confirmPasswordTextField = confirmPasswordField.textField

        emailStack = emailField.stack
        passwordStack = passwordField.stack
        confirmPasswordStack = confirmPasswordField.stack

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Инициализатор не реализован")
    }
}

// MARK: - Lifecycle

extension AuthViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.insertSublayer(gradientLayer, at: 0)
        setupLayout()
        setupActions()
        bindViewModel()
        updateUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
}

// MARK: - Private Methods

private extension AuthViewController {

    static func makeFieldStack(
        labelText: String,
        placeholder: String,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        iconName: String
    ) -> (stack: UIStackView, textField: UITextField) {
        let label = UILabel()
        label.text = labelText
        label.font = .systemFont(ofSize: 14, weight: .medium)

        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = isSecure
        textField.keyboardType = keyboardType
        textField.autocapitalizationType = .none
        textField.leftView = makeIconView(systemName: iconName)
        textField.leftViewMode = .always

        let stack = UIStackView(arrangedSubviews: [label, textField])
        stack.axis = .vertical
        stack.spacing = Constants.fieldSpacing

        return (stack, textField)
    }

    static func makeIconView(systemName: String) -> UIView {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 50))
        let imageView = UIImageView(image: UIImage(systemName: systemName))
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 10, y: 15, width: 20, height: 20)
        container.addSubview(imageView)
        return container
    }

    func bindViewModel() {
        viewModel.onError = { [weak self] error in
            guard let self else { return }
            let alert = UIAlertController(
                title: Constants.Strings.errorTitle,
                message: error,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: Constants.Strings.errorAction, style: .default))
            present(alert, animated: true)
        }
    }

    func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(cardView)
        cardView.addSubview(iconContainerView)
        iconContainerView.addSubview(iconImageView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(subtitleLabel)
        cardView.addSubview(emailStack)
        cardView.addSubview(passwordStack)
        cardView.addSubview(confirmPasswordStack)
        cardView.addSubview(actionButton)
        cardView.addSubview(switchButton)

        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview()
        }

        cardView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.cardHorizontalInset)
            $0.centerY.equalToSuperview()
            $0.top.greaterThanOrEqualToSuperview().offset(Constants.cardVerticalInset)
            $0.bottom.lessThanOrEqualToSuperview().inset(Constants.cardVerticalInset)
        }

        iconContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(Constants.iconSize)
        }

        iconImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(Constants.iconImageSize)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconContainerView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        emailStack.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        emailTextField.snp.makeConstraints {
            $0.height.equalTo(Constants.textFieldHeight)
        }

        passwordStack.snp.makeConstraints {
            $0.top.equalTo(emailStack.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(Constants.textFieldHeight)
        }

        confirmPasswordStack.snp.makeConstraints {
            $0.top.equalTo(passwordStack.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        confirmPasswordTextField.snp.makeConstraints {
            $0.height.equalTo(Constants.textFieldHeight)
        }

        actionButton.snp.makeConstraints {
            $0.top.equalTo(confirmPasswordStack.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(Constants.buttonHeight)
        }

        switchButton.snp.makeConstraints {
            $0.top.equalTo(actionButton.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
        }
    }

    func setupActions() {
        actionButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        switchButton.addTarget(self, action: #selector(switchTapped), for: .touchUpInside)
    }

    func updateUI() {
        switch state {
        case .login:
            titleLabel.text = Constants.Strings.loginTitle
            subtitleLabel.text = Constants.Strings.loginSubtitle
            passwordTextField.placeholder = Constants.Strings.loginPasswordPlaceholder
            confirmPasswordStack.isHidden = true
            actionButton.setTitle(Constants.Strings.loginAction, for: .normal)
            switchButton.setTitle(Constants.Strings.loginSwitch, for: .normal)

        case .register:
            titleLabel.text = Constants.Strings.registerTitle
            subtitleLabel.text = Constants.Strings.registerSubtitle
            passwordTextField.placeholder = Constants.Strings.registerPasswordPlaceholder
            confirmPasswordStack.isHidden = false
            actionButton.setTitle(Constants.Strings.registerAction, for: .normal)
            switchButton.setTitle(Constants.Strings.registerSwitch, for: .normal)
        }
    }

    @objc func actionTapped() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }

        switch state {
        case .login:
            viewModel.signIn(email: email, password: password)
        case .register:
            guard let confirmPassword = confirmPasswordTextField.text else { return }
            viewModel.register(email: email, password: password, confirmPassword: confirmPassword)
        }
    }

    @objc func switchTapped() {
        state = (state == .login) ? .register : .login
    }
}
