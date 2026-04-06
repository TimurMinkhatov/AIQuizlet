import Foundation

class RegisterViewModel {
    
    weak var coordinator: AuthCoordinator?
    private let authService = AuthService.shared
    
    var email: String = ""
    var password: String = ""
    
    var onError: ((String) -> Void)?
    
    func register() {
        guard validateForm() else { return }
        
        authService.register(email: email, password: password) { [weak self] authResult in
                switch authResult {
                case .success:
                    self?.coordinator?.didFinishAuth()
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
            }
        }
    }
    
    func validateForm() -> Bool {
        let emailValid = email.contains("@") && email.contains(".") && !email.isEmpty
        let passwordValid = password.count >= 6 && !password.isEmpty
        
        if !emailValid { onError?("Введите корректный email"); return false }
        if !passwordValid { onError?("Пароль должен быть не менее 6 символов"); return false }
        
        return true
    }
}
