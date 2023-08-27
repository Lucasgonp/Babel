import FirebaseFirestoreSwift

public protocol AuthenticatorSaveUserProtocol: AnyObject {
    func saveUserToFirestore(_ user: User, thread: DispatchQueue, completion: @escaping (Error?) -> Void)
}

extension AuthenticatorAdapter: AuthenticatorSaveUserProtocol {
    public func saveUserToFirestore(_ user: User, thread: DispatchQueue = .main, completion: @escaping (Error?) -> Void) {
        AuthenticationStorage.saveUserLocally(user)
        
        do {
            try firebaseReference(.user).document(user.id).setData(from: user, completion: { error in
                thread.async {
                    completion(error)
                }
            })
        } catch let error {
            print(error.localizedDescription, "Error in saveUserToFirestore")
            thread.async {
                completion(error)
            }
        }
    }
}
