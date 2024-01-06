import FirebaseAuth

protocol RegisterServicing {
    func register(userRequest: RegisterUserRequestModel, completion: @escaping (AuthError?) -> Void)
}

final class RegisterService {
    private let authService: RegisterProtocol
    
    init(authService: RegisterProtocol) {
        self.authService = authService
    }
}

// MARK: - RegisterServicing
extension RegisterService: RegisterServicing {
    func register(userRequest: RegisterUserRequestModel, completion: @escaping (AuthError?) -> Void) {
        authService.registerUser(with: userRequest, thread: .main) { didSuccess, error in
            if let error {
                completion(.custom(error))
                return
            }
            
            if didSuccess {
                completion(nil)
            } else {
                completion(.genericError)
            }
        }
    }
}
