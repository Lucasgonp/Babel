import FirebaseAuth

protocol LoginServicing {
    func login(userRequest: LoginUserModel, completion: @escaping (Result<AuthLoginCredentials, AuthError>) -> Void)
}

final class LoginService {
    private let authService: LoginProtocol
    
    init(authService: LoginProtocol) {
        self.authService = authService
    }
}

// MARK: - LoginServicing
extension LoginService: LoginServicing {
    func login(userRequest: LoginUserModel, completion: @escaping (Result<AuthLoginCredentials, AuthError>) -> Void) {
        authService.login(with: userRequest) { (result, error) in
            if let error {
                completion(.failure(.custom(error)))
                return
            }
            
            guard let result else {
                completion(.failure(.genericError))
                return
            }
            
            completion(.success(AuthLoginCredentials(authDataResult: result)))
        }
    }
}
