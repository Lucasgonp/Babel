public protocol AuthenticatorResetPasswordProtocol {
    func resetPassword(email: String, completion: @escaping (Error?) -> Void)
}

extension AuthenticatorAdapter: AuthenticatorResetPasswordProtocol {
    public func resetPassword(email: String, completion: @escaping (Error?) -> Void) {
        auth.sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
}
