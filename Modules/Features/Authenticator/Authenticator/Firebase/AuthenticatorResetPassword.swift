public protocol AuthenticatorResetPasswordProtocol {
    func resetPassword(email: String, thread: DispatchQueue, completion: @escaping (Error?) -> Void)
}

extension AuthenticatorAdapter: AuthenticatorResetPasswordProtocol {
    public func resetPassword(email: String, thread: DispatchQueue = .main, completion: @escaping (Error?) -> Void) {
        auth.sendPasswordReset(withEmail: email) { error in
            thread.async {
                completion(error)
            }
        }
    }
}
