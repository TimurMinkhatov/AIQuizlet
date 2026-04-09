//
//  AuthViewController.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 07/04/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit
import SnapKit

class AuthViewController: UIViewController {
    
    private let viewModel: AuthViewModel
    private var state: AuthState = .login {
        didSet { updateUI() }
    }
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let gradientLayer = CAGradientLayer()
    private let cardView = UIView()
    private let iconContainerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let emailLabel = UILabel()
    private let emailTextField = UITextField()
    private let passwordLabel = UILabel()
    private let passwordTextField = UITextField()
    private let confirmPasswordLabel = UILabel()
    private let confirmPasswordTextField = UITextField()
    private let actionButton = UIButton()
    private let switchButton = UIButton()
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Инициализатор не реализован")
    }
}

extension AuthViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()
        setupUI()
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

private extension AuthViewController {
    
    enum Constants {
        static let cardHorizontalInset: CGFloat = 20
        static let cardVerticalInset: CGFloat = 60
        static let iconSize: CGFloat = 80
        static let iconImageSize: CGFloat = 40
        static let iconCornerRadius: CGFloat = 40
        static let cardCornerRadius: CGFloat = 20
        static let buttonCornerRadius: CGFloat = 12
        static let textFieldHeight: CGFloat = 50
        static let buttonHeight: CGFloat = 50
    }
    
    func setupGradient() {
        gradientLayer.colors = [
            UIColor(red: 0.2, green: 0.4, blue: 1.0, alpha: 1.0).cgColor,
            UIColor(red: 0.5, green: 0.2, blue: 0.9, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupUI() {
        scrollView.keyboardDismissMode = .onDrag
        scrollView.showsVerticalScrollIndicator = false
        
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = Constants.cardCornerRadius
        
        iconContainerView.backgroundColor = UIColor(red: 0.9, green: 0.93, blue: 1.0, alpha: 1.0)
        iconContainerView.layer.cornerRadius = Constants.iconCornerRadius
        
        iconImageView.image = UIImage(systemName: "book")
        iconImageView.tintColor = .systemBlue
        iconImageView.contentMode = .scaleAspectFit
        
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center
        
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .gray
        subtitleLabel.textAlignment = .center
        
        emailLabel.text = "Email"
        emailLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
        emailTextField.placeholder = "example@email.com"
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.leftView = makeIconView(systemName: "envelope")
        emailTextField.leftViewMode = .always
        
        passwordLabel.text = "Пароль"
        passwordLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.leftView = makeIconView(systemName: "lock")
        passwordTextField.leftViewMode = .always
        
        confirmPasswordLabel.text = "Подтвердите пароль"
        confirmPasswordLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
        confirmPasswordTextField.placeholder = "Повторите пароль"
        confirmPasswordTextField.borderStyle = .roundedRect
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.leftView = makeIconView(systemName: "lock")
        confirmPasswordTextField.leftViewMode = .always
        
        actionButton.backgroundColor = .systemGray4
        actionButton.layer.cornerRadius = Constants.buttonCornerRadius
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        
        switchButton.setTitleColor(.systemBlue, for: .normal)
        switchButton.titleLabel?.font = .systemFont(ofSize: 14)
    }
    
    func makeIconView(systemName: String) -> UIView {
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
