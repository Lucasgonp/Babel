public protocol CheckAuthenticationProtocol {
    func checkAuthentication(thread: DispatchQueue, completion: @escaping (AuthCheckCredentials?) -> Void)
}

extension AuthenticatorAdapter: CheckAuthenticationProtocol {
    public func checkAuthentication(thread: DispatchQueue = DispatchQueue.main, completion: @escaping (AuthCheckCredentials?) -> Void) {
        if let firebaseUser = auth.currentUser,
           firebaseUser.isEmailVerified {
            syncLocalUserFromFirebase(userId: firebaseUser.uid, email: firebaseUser.email) { user in
                guard let user else {
                    thread.async {
                        completion(nil)
                    }
                    return
                }
                let credentials = AuthCheckCredentials(user: user, firebaseUser: firebaseUser)
                AccountInfo.shared.user = user
                AccountInfo.shared.firebaseUser = firebaseUser
                thread.async {
                    completion(credentials)
                }
            }
        } else {
            logout { _ in
                thread.async {
                    completion(nil)
                }
            }
        }
    }
}
