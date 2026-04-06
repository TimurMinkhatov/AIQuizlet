import UIKit
import SnapKit

class RegisterViewController: UIViewController {
    
    private let viewModel: RegisterViewModel
    
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("Инициализатор не реализован")
    }

    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    
    private let registerButton = UIButton()
    private let goToLoginButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupActions()
        
        viewModel.onError = { [weak self] error in
            let alert = UIAlertController(title: "Ошибка", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .purple
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        
        passwordTextField.placeholder = "Пароль"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        
        registerButton.setTitle("Зарегистрироваться", for: .normal)
        registerButton.backgroundColor = .systemBlue
        registerButton.layer.cornerRadius = 8.0
        
        goToLoginButton.setTitle("Уже есть аккаунт? Войти", for: .normal)
        goToLoginButton.setTitleColor(.systemBlue, for: .normal)
        
    }
    
    private func setupLayout() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
        view.addSubview(goToLoginButton)
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        goToLoginButton.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupActions() {
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        goToLoginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }
    
    @objc func registerTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        viewModel.email = email
        viewModel.password = password
        viewModel.register()
    }
    
    @objc func loginTapped() {
        viewModel.coordinator?.showLogin()
    }
}
