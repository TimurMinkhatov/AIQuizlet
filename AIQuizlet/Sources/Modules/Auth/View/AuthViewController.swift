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
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Инициализатор не реализован")
    }
    
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
    private var cardBottomConstraint: Constraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()
        setupUI()
        setupLayout()
        setupActions()
        updateUI()
        
        viewModel.onError = { [weak self] error in
            let alert = UIAlertController(title: "Ошибка", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(red: 0.2, green: 0.4, blue: 1.0, alpha: 1.0).cgColor,
            UIColor(red: 0.5, green: 0.2, blue: 0.9, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupUI() {
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 20
        
        iconContainerView.backgroundColor = UIColor(red: 0.9, green: 0.93, blue: 1.0, alpha: 1.0)
        iconContainerView.layer.cornerRadius = 40
        
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
        emailTextField.keyboardType = .default
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
        actionButton.layer.cornerRadius = 12
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        
        switchButton.setTitleColor(.systemBlue, for: .normal)
        switchButton.titleLabel?.font = .systemFont(ofSize: 14)
    }
    
    private func makeIconView(systemName: String) -> UIView {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 50))
        let imageView = UIImageView(image: UIImage(systemName: systemName))
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 10, y: 15, width: 20, height: 20)
        container.addSubview(imageView)
        return container
    }
    
    private func setupLayout() {
        view.addSubview(cardView)
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
        
        cardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.greaterThanOrEqualToSuperview().offset(60)
            cardBottomConstraint = make.bottom.equalToSuperview().inset(120).constraint
        }
        
        iconContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconContainerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        confirmPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        switchButton.snp.makeConstraints { make in
            make.top.equalTo(actionButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    private func setupActions() {
        actionButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        switchButton.addTarget(self, action: #selector(switchTapped), for: .touchUpInside)
    }
    
    private func updateUI() {
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
    
    @objc private func actionTapped() {
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
    
    @objc private func switchTapped() {
        state = (state == .login) ? .register : .login
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        
        UIView.animate(withDuration: duration) {
            self.cardBottomConstraint?.update(inset: 120)
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        
        UIView.animate(withDuration: duration) {
            self.cardBottomConstraint?.update(inset: keyboardFrame.height + 20)
            self.view.layoutIfNeeded()
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
