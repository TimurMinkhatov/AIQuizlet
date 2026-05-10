//
//  AuthViewController.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 07/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - AuthViewController

final class AuthViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: AuthViewModel

    private var state: AuthState = .login {
        didSet { updateUI() }
    }
    
    // MARK: - UI Components

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .onDrag
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private lazy var contentView = UIView()

    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        view.applyGradient(colors: [
            UIColor(red: 21/255, green: 93/255, blue: 252/255, alpha: 1),
            UIColor(red: 152/255, green: 16/255, blue: 250/255, alpha: 1)
        ], startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1), cornerRadius: 10)
        return layer
    }()

    private lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.cardCornerRadius
        return view
    }()

    private lazy var iconContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.9, green: 0.93, blue: 1.0, alpha: 1.0)
        view.layer.cornerRadius = Constants.iconCornerRadius
        return view
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "book")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.titleFontSize)
        label.textAlignment = .center
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.subtitleFontSize)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()

    private lazy var emailField = FormFieldView(
        labelText: L10n.Auth.Email.label,
        placeholder: L10n.Auth.Email.placeholder,
        keyboardType: .emailAddress,
        iconName: "envelope"
    )

    private lazy var passwordField = FormFieldView(
        labelText: L10n.Auth.Password.label,
        placeholder: L10n.Auth.Password.placeholder,
        isSecure: true,
        iconName: "lock"
    )

    private lazy var confirmPasswordField = FormFieldView(
        labelText: L10n.Auth.ConfirmPassword.label,
        placeholder: L10n.Auth.ConfirmPassword.placeholder,
        isSecure: true,
        iconName: "lock"
    )

    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Constants.buttonFontSize, weight: .semibold)
        return button
    }()

    private lazy var switchButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Constants.switchButtonFontSize)
        return button
    }()

    // MARK: - Init

    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            self?.scrollView.contentInset.bottom = keyboardFrame.height
            self?.scrollView.verticalScrollIndicatorInsets.bottom = keyboardFrame.height
        }

        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.scrollView.contentInset.bottom = 0
            self?.scrollView.verticalScrollIndicatorInsets.bottom = 0
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
}

// MARK: - Private Methods

private extension AuthViewController {

    func bindViewModel() {
        viewModel.onError = { [weak self] error in
            guard let self else { return }
            let alert = UIAlertController(
                title: L10n.Common.Error.title,
                message: error,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: L10n.Common.ok, style: .default))
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
        cardView.addSubview(emailField)
        cardView.addSubview(passwordField)
        cardView.addSubview(confirmPasswordField)
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
            $0.top.greaterThanOrEqualToSuperview().offset(Constants.cardVerticalInset)
            $0.bottom.lessThanOrEqualToSuperview().inset(Constants.cardVerticalInset)
        }

        iconContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.iconTopOffset)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(Constants.iconSize)
        }

        iconImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(Constants.iconImageSize)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconContainerView.snp.bottom).offset(Constants.titleTopOffset)
            $0.leading.trailing.equalToSuperview().inset(Constants.fieldHorizontalInset)
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.subtitleTopOffset)
            $0.leading.trailing.equalToSuperview().inset(Constants.fieldHorizontalInset)
        }

        emailField.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(Constants.emailTopOffset)
            $0.leading.trailing.equalToSuperview().inset(Constants.fieldHorizontalInset)
        }

        passwordField.snp.makeConstraints {
            $0.top.equalTo(emailField.snp.bottom).offset(Constants.fieldSpacing)
            $0.leading.trailing.equalToSuperview().inset(Constants.fieldHorizontalInset)
        }

        confirmPasswordField.snp.makeConstraints {
            $0.top.equalTo(passwordField.snp.bottom).offset(Constants.fieldSpacing)
            $0.leading.trailing.equalToSuperview().inset(Constants.fieldHorizontalInset)
        }

        actionButton.snp.makeConstraints {
            $0.top.equalTo(confirmPasswordField.snp.bottom).offset(Constants.fieldSpacing)
            $0.leading.trailing.equalToSuperview().inset(Constants.fieldHorizontalInset)
            $0.height.equalTo(Constants.buttonHeight)
        }

        switchButton.snp.makeConstraints {
            $0.top.equalTo(actionButton.snp.bottom).offset(Constants.fieldSpacing)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(Constants.switchButtonBottomInset)
        }
    }

    func setupActions() {
        actionButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        switchButton.addTarget(self, action: #selector(switchTapped), for: .touchUpInside)
    }

    func updateUI() {
        switch state {
        case .login:
            titleLabel.text = L10n.Auth.Login.title
            subtitleLabel.text = L10n.Auth.Login.subtitle
            passwordField.setPlaceholder(L10n.Auth.Password.placeholder)
            confirmPasswordField.isHidden = true
            actionButton.setTitle(L10n.Auth.Login.button, for: .normal)
            switchButton.setTitle(L10n.Auth.switchToRegister, for: .normal)
            actionButton.snp.remakeConstraints {
                $0.top.equalTo(passwordField.snp.bottom).offset(Constants.fieldSpacing)
                $0.leading.trailing.equalToSuperview().inset(Constants.fieldHorizontalInset)
                $0.height.equalTo(Constants.buttonHeight)
            }
            cardView.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview().inset(Constants.cardHorizontalInset)
                $0.top.greaterThanOrEqualToSuperview().offset(Constants.loginCardTopInset)
                $0.bottom.lessThanOrEqualToSuperview().inset(Constants.loginCardBottomInset)
                $0.centerY.equalToSuperview().offset(Constants.loginCardCenterOffset)
            }

        case .register:
            titleLabel.text = L10n.Auth.Register.title
            subtitleLabel.text = L10n.Auth.Register.subtitle
            passwordField.setPlaceholder(L10n.Auth.Password.registerPlaceholder)
            confirmPasswordField.isHidden = false
            actionButton.setTitle(L10n.Auth.Register.button, for: .normal)
            switchButton.setTitle(L10n.Auth.switchToLogin, for: .normal)
            actionButton.snp.remakeConstraints {
                $0.top.equalTo(confirmPasswordField.snp.bottom).offset(Constants.fieldSpacing)
                $0.leading.trailing.equalToSuperview().inset(Constants.fieldHorizontalInset)
                $0.height.equalTo(Constants.buttonHeight)
            }
            cardView.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview().inset(Constants.cardHorizontalInset)
                $0.top.greaterThanOrEqualToSuperview().offset(Constants.registerCardTopInset)
                $0.bottom.lessThanOrEqualToSuperview().inset(Constants.registerCardBottomInset)
                $0.centerY.equalToSuperview().offset(Constants.registerCardCenterOffset)
            }
        }
    }

    @objc func actionTapped() {
        guard let email = emailField.text,
              let password = passwordField.text else { return }

        switch state {
        case .login:
            viewModel.signIn(email: email, password: password)
        case .register:
            guard let confirmPassword = confirmPasswordField.text else { return }
            viewModel.register(email: email, password: password, confirmPassword: confirmPassword)
        }
    }

    @objc func switchTapped() {
        state = (state == .login) ? .register : .login
    }
}

// MARK: - Constants

private extension AuthViewController {
    enum Constants {
        static let cardCornerRadius: CGFloat = 20
        static let cardHorizontalInset: CGFloat = 20
        static let cardVerticalInset: CGFloat = 60

        static let loginCardTopInset: CGFloat = 150
        static let loginCardBottomInset: CGFloat = 180
        static let loginCardCenterOffset: CGFloat = -153

        static let registerCardTopInset: CGFloat = 106
        static let registerCardBottomInset: CGFloat = 135
        static let registerCardCenterOffset: CGFloat = -106

        static let iconCornerRadius: CGFloat = 40
        static let iconSize: CGFloat = 80
        static let iconImageSize: CGFloat = 40
        static let iconTopOffset: CGFloat = 24

        static let titleFontSize: CGFloat = 28
        static let subtitleFontSize: CGFloat = 14
        static let titleTopOffset: CGFloat = 16
        static let subtitleTopOffset: CGFloat = 8

        static let fieldHorizontalInset: CGFloat = 20
        static let fieldSpacing: CGFloat = 16
        static let emailTopOffset: CGFloat = 24

        static let buttonCornerRadius: CGFloat = 12
        static let buttonHeight: CGFloat = 50
        static let buttonFontSize: CGFloat = 16
        static let switchButtonFontSize: CGFloat = 14
        static let switchButtonBottomInset: CGFloat = 24
    }
}
