import Authenticator

protocol EditBioServicing {
    func saveUserToFirebase(user: User, completion: @escaping (Error?) -> Void)
}

final class EditBioService {
    private let authManager: AuthenticatorSaveUserProtocol
    
    init(authManager: AuthenticatorSaveUserProtocol) {
        self.authManager = authManager
    }
}

// MARK: - EditBioServicing
extension EditBioService: EditBioServicing {
    func saveUserToFirebase(user: User, completion: @escaping (Error?) -> Void) {
        authManager.saveUserToFirestore(user, thread: .main, completion: completion)
    }
}
