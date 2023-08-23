import FirebaseAuth

public protocol LoginProtocol {
    func login(with userRequest: LoginUserRequestModel, completion: @escaping ((Result<UserGlobalModel, AuthError>)) -> Void)
}

extension AuthenticatorAdapter: LoginProtocol {
    public func login(with userRequest: LoginUserRequestModel, completion: @escaping ((Result<UserGlobalModel, AuthError>) -> Void)) {
        auth.signIn(withEmail: userRequest.email, password: userRequest.password) { [weak self] (result, error) in
            if let error {
                completion(.failure(.custom(error)))
                return
            }
            
            guard let result else {
                completion(.failure(.errorLogin))
                return
            }
            
            AccountInfo.shared.firebaseUser = result.user
            self?.syncLocalUserFromFirebase(userId: result.user.uid, email: userRequest.email)
            
            let model = UserGlobalModel(authDataResult: result)
            completion(.success(model))
        }
    }
}

private extension AuthenticatorAdapter {
    func syncLocalUserFromFirebase(userId: String, email: String? = nil) {
        firebaseReference(.user).document(userId).getDocument { [weak self] document, error in
            if let error {
                print("Error syncUserFromFirebase: \(error.localizedDescription)")
                return
            }
            
            guard let document else {
                print("Error get document from syncUserFromFirebase")
                return
            }
            
            let result = Result {
                try? document.data(as: User.self)
            }
            
            switch result {
            case .success(let user):
                if let user {
                    self?.saveUserLocally(user)
                } else {
                    print("Error deconding user")
                }
            case .failure(let error):
                print("Error deconding user: \(error.localizedDescription)")
            }
        }
    }
}
