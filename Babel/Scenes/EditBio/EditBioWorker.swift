import Authenticator

protocol EditBioWorkerProtocol {
    func saveUserToFirebase(user: User, completion: @escaping (Error?) -> Void)
}

final class EditBioWorker {
    private let authManager: AuthenticatorSaveUserProtocol
    
    init(authManager: AuthenticatorSaveUserProtocol) {
        self.authManager = authManager
    }
}

// MARK: - EditBioWorkerProtocol
extension EditBioWorker: EditBioWorkerProtocol {
    func saveUserToFirebase(user: User, completion: @escaping (Error?) -> Void) {
        authManager.saveUserToFirestore(user, thread: .main, completion: completion)
    }
}
