import NetworkKit

public protocol AuthenticatorSaveUserProtocol: AnyObject {
    func saveUserToFirestore(_ user: User, completion: @escaping (Error?) -> Void)
}

extension AuthenticatorAdapter: AuthenticatorSaveUserProtocol {
    public func saveUserToFirestore(_ user: User, completion: @escaping (Error?) -> Void) {
        AuthenticationStorage.saveUserLocally(user)
        
        DispatchQueue.global().async {
            do {
                try FirebaseClient.shared.firebaseReference(.user).document(user.id).setData(from: user, completion: { error in
                    DispatchQueue.main.async {
                        completion(error)
                    }
                })
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
}
