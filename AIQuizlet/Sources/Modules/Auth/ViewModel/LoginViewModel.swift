import Foundation

class LoginViewModel {
    
    weak var coordinator: AuthCoordinator?
    private let authService = AuthService.shared
 
    var email: String = ""
    var password: String = ""
    
    func signIn() {
        authService.signIn(email: email, password: password) { [weak self] authResult in
                switch authResult {
                case .success:
                    self?.coordinator?.didFinishAuth()
                case .failure:
                    print("Ошибка авторизации")
            }
        }
    }
}
