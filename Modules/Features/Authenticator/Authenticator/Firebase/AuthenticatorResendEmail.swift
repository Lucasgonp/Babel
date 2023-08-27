public protocol AuthenticatorResendEmailProtocol {
    func resentEmailVerification(thread: DispatchQueue, completion: @escaping (Error?) -> Void)
}

extension AuthenticatorAdapter: AuthenticatorResendEmailProtocol {
    public func resentEmailVerification(thread: DispatchQueue = .main, completion: @escaping (Error?) -> Void) {
        auth.currentUser?.reload(completion: { [weak self] error in
            if let error {
                thread.async {
                    completion(error)
                }
                return
            }
            
            self?.auth.currentUser?.sendEmailVerification(completion: { error in
                thread.async {
                    completion(error)
                }
            })
        })
    }
}
