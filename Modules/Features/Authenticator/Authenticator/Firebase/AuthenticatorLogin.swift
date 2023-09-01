import FirebaseAuth
import NetworkKit

public protocol LoginProtocol {
    func login(with userRequest: LoginUserRequestModel, thread: DispatchQueue, completion: @escaping ((Result<UserGlobalModel, AuthError>) -> Void))
}

extension AuthenticatorAdapter: LoginProtocol {
    public func login(with userRequest: LoginUserRequestModel, thread: DispatchQueue = .main, completion: @escaping ((Result<UserGlobalModel, AuthError>) -> Void)) {
        auth.signIn(withEmail: userRequest.email, password: userRequest.password) { [weak self] (result, error) in
            if let error {
                thread.async {
                    return completion(.failure(.custom(error)))
                }
            }
            
            guard let result else {
                thread.async {
                    completion(.failure(.errorLogin))
                }
                return
            }
            
            AccountInfo.shared.firebaseUser = result.user
            self?.syncLocalUserFromFirebase(userId: result.user.uid, email: userRequest.email) { _ in
                let model = UserGlobalModel(authDataResult: result)
                thread.async {
                    completion(.success(model))
                }
            }
        }
    }
}

extension AuthenticatorAdapter {
    func syncLocalUserFromFirebase(userId: String, email: String? = nil, completion: @escaping (User?) -> Void) {
        FirebaseClient.shared.firebaseReference(.user).document(userId).getDocument { document, error in
            if let error {
                print("Error syncUserFromFirebase: \(error.localizedDescription)")
                return completion(nil)
            }
            
            guard let document else {
                print("Error get document from syncUserFromFirebase")
                return completion(nil)
            }
            
            let result = Result {
                try? document.data(as: User.self)
            }
            
            switch result {
            case .success(let user):
                if let user {
                    AuthenticationStorage.saveUserLocally(user)
                    completion(user)
                } else {
                    print("Error deconding user")
                    completion(nil)
                }
            case .failure(let error):
                print("Error deconding user: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}
