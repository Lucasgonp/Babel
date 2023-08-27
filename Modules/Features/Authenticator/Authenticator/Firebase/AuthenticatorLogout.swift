import StorageKit

public protocol LogoutProtocol {
    func logout(thread: DispatchQueue, completion: @escaping (Error?) -> Void)
}

extension AuthenticatorAdapter: LogoutProtocol {
    public func logout(thread: DispatchQueue = .main, completion: @escaping (Error?) -> Void) {
        do {
            try auth.signOut()
            StorageLocal.shared.removeStorageData(key: .currentUser)
            thread.async {
                completion(nil)
            }
        } catch let error {
            thread.async {
                completion(error)
            }
        }
    }
}
