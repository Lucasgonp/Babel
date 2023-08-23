import CoreKit

public protocol CheckAuthenticationProtocol {
    func checkAuthentication(completion: @escaping (AuthCheckCredentials?) -> Void)
}

extension AuthenticatorAdapter: CheckAuthenticationProtocol {
    public func checkAuthentication(completion: @escaping (AuthCheckCredentials?) -> Void) {
        if let firebaseUser = auth.currentUser,
           let user: User = StorageManager.shared.getStorageObject(for: .currentUser),
           firebaseUser.isEmailVerified {
            let credentials = AuthCheckCredentials(user: user, firebaseUser: firebaseUser)
            AccountInfo.shared.user = user
            AccountInfo.shared.firebaseUser = firebaseUser
            completion(credentials)
        } else {
            logout { _ in
                completion(nil)
            }
        }
    }
}
