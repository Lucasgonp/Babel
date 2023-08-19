public protocol AuthenticatorResendEmailProtocol {
    func resentEmailVerification(completion: @escaping (Error?) -> Void)
}

extension AuthenticatorAdapter: AuthenticatorResendEmailProtocol {
    public func resentEmailVerification(completion: @escaping (Error?) -> Void) {
        auth.currentUser?.reload(completion: { [weak self] error in
            if let error {
                completion(error)
                return
            }
            
            self?.auth.currentUser?.sendEmailVerification(completion: { error in
                completion(error)
            })
        })
    }
}
