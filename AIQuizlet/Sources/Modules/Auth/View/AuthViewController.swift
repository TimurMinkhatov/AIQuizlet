//
//  AuthViewController.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 07/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

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
    }
}

class AuthViewController: UIViewController {
    
    private let viewModel: AuthViewModel
    private var state: AuthState = .login {
        didSet { updateUI() }
    }
    
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
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "example@email.com"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.leftView = AuthViewController.makeIconView(systemName: "envelope")
        textField.leftViewMode = .always
        return textField
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Пароль"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.leftView = AuthViewController.makeIconView(systemName: "lock")
        textField.leftViewMode = .always
        return textField
    }()
    
    private let confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Подтвердите пароль"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Повторите пароль"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.leftView = AuthViewController.makeIconView(systemName: "lock")
        textField.leftViewMode = .always
        return textField
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
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
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
        updateUI()
        
        viewModel.onError = { [weak self] error in
            guard let self else { return }
            let alert = UIAlertController(title: "Ошибка", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
}

// MARK: - Private
private extension AuthViewController {
    
    static func makeIconView(systemName: String) -> UIView {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 50))
        let imageView = UIImageView(image: UIImage(systemName: systemName))
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 10, y: 15, width: 20, height: 20)
        container.addSubview(imageView)
        return container
    }
    
    func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(cardView)
        cardView.addSubview(iconContainerView)
        iconContainerView.addSubview(iconImageView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(subtitleLabel)
        cardView.addSubview(emailLabel)
        cardView.addSubview(emailTextField)
        cardView.addSubview(passwordLabel)
        cardView.addSubview(passwordTextField)
        cardView.addSubview(confirmPasswordLabel)
        cardView.addSubview(confirmPasswordTextField)
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
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(Constants.textFieldHeight)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(Constants.textFieldHeight)
        }
        
        confirmPasswordLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        confirmPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(confirmPasswordLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(Constants.textFieldHeight)
        }
        
        actionButton.snp.makeConstraints {
            $0.top.equalTo(confirmPasswordTextField.snp.bottom).offset(24)
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
            titleLabel.text = "Добро пожаловать!"
            subtitleLabel.text = "Войдите в свой аккаунт"
            passwordTextField.placeholder = "······"
            confirmPasswordLabel.isHidden = true
            confirmPasswordTextField.isHidden = true
            actionButton.setTitle("Войти", for: .normal)
            switchButton.setTitle("Нет аккаунта? Зарегистрироваться", for: .normal)
            
        case .register:
            titleLabel.text = "Создать аккаунт"
            subtitleLabel.text = "Зарегистрируйтесь для начала работы"
            passwordTextField.placeholder = "Минимум 6 символов"
            confirmPasswordLabel.isHidden = false
            confirmPasswordTextField.isHidden = false
            actionButton.setTitle("Зарегистрироваться", for: .normal)
            switchButton.setTitle("Уже есть аккаунт? Войти", for: .normal)
        }
    }
    
    @objc func actionTapped() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        viewModel.email = email
        viewModel.password = password
        
        switch state {
        case .login:
            viewModel.signIn()
        case .register:
            guard let confirmPassword = confirmPasswordTextField.text else { return }
            viewModel.confirmPassword = confirmPassword
            viewModel.register()
        }
    }
    
    @objc func switchTapped() {
        state = (state == .login) ? .register : .login
    }
}
