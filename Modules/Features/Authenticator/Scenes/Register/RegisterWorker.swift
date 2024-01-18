import FirebaseAuth

protocol RegisterWorkerProtocol {
    func register(userRequest: RegisterUserRequestModel, completion: @escaping (AuthError?) -> Void)
}

final class RegisterWorker {
    private let authWorker: RegisterProtocol
    
    init(authWorker: RegisterProtocol) {
        self.authWorker = authWorker
    }
}

extension RegisterWorker: RegisterWorkerProtocol {
    func register(userRequest: RegisterUserRequestModel, completion: @escaping (AuthError?) -> Void) {
        authWorker.registerUser(with: userRequest, thread: .main) { didSuccess, error in
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
