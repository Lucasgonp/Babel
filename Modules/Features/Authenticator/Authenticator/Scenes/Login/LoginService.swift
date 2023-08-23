import FirebaseAuth

protocol LoginServicing {
    func login(userRequest: LoginUserRequestModel, completion: @escaping (Result<UserGlobalModel, AuthError>) -> Void)
    func resendEmailVerification(completion: @escaping (Error?) -> Void)
    func resetPassword(email: String, completion: @escaping (Error?) -> Void)
}

final class LoginService {
    typealias AuthService = LoginProtocol &
                            AuthenticatorResendEmailProtocol &
                            AuthenticatorResetPasswordProtocol
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
}

// MARK: - LoginServicing
extension LoginService: LoginServicing {
    func login(userRequest: LoginUserRequestModel, completion: @escaping (Result<UserGlobalModel, AuthError>) -> Void) {
        authService.login(with: userRequest) { result in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                completion(.failure(.custom(error)))
            }
        }
    }
    
    func resendEmailVerification(completion: @escaping (Error?) -> Void) {
        authService.resentEmailVerification(completion: completion)
    }
    
    func resetPassword(email: String, completion: @escaping (Error?) -> Void) {
        authService.resetPassword(email: email, completion: completion)
    }
}
