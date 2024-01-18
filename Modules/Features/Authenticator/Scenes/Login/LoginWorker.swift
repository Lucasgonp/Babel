import FirebaseAuth

protocol LoginWorkerProtocol {
    func login(userRequest: LoginUserRequestModel, completion: @escaping (Result<UserGlobalModel, AuthError>) -> Void)
    func resendEmailVerification(completion: @escaping (Error?) -> Void)
    func resetPassword(email: String, completion: @escaping (Error?) -> Void)
}

final class LoginWorker {
    typealias AuthWorker = LoginProtocol &
                            AuthenticatorResendEmailProtocol &
                            AuthenticatorResetPasswordProtocol
    private let authWorker: AuthWorker
    
    init(authWorker: AuthWorker) {
        self.authWorker = authWorker
    }
}

// MARK: - LoginWorkerProtocol
extension LoginWorker: LoginWorkerProtocol {
    func login(userRequest: LoginUserRequestModel, completion: @escaping (Result<UserGlobalModel, AuthError>) -> Void) {
        authWorker.login(with: userRequest, thread: .main) { result in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                completion(.failure(.custom(error)))
            }
        }
    }
    
    func resendEmailVerification(completion: @escaping (Error?) -> Void) {
        authWorker.resentEmailVerification(thread: .main, completion: completion)
    }
    
    func resetPassword(email: String, completion: @escaping (Error?) -> Void) {
        authWorker.resetPassword(email: email, thread: .main, completion: completion)
    }
}
