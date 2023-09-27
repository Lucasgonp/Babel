import NetworkKit

public protocol AuthenticatorSaveUserProtocol: AnyObject {
    func saveUserToFirestore(_ user: User, thread: DispatchQueue, completion: @escaping (Error?) -> Void)
}

extension AuthenticatorAdapter: AuthenticatorSaveUserProtocol {
    public func saveUserToFirestore(_ user: User, thread: DispatchQueue = .main, completion: @escaping (Error?) -> Void) {
        AuthenticationStorage.saveUserLocally(user)
        
        do {
            try FirebaseClient.shared.firebaseReference(.user).document(user.id).setData(from: user, completion: { error in
                thread.async {
                    completion(error)
                }
            })
        } catch {
            thread.async {
                completion(error)
            }
        }
    }
}
