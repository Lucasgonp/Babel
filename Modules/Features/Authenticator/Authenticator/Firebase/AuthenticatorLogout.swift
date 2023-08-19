import CoreKit

public protocol LogoutProtocol {
    func logout(completion: @escaping (Error?) -> Void)
}

extension AuthenticatorAdapter: LogoutProtocol {
    public func logout(completion: @escaping (Error?) -> Void) {
        do {
            try auth.signOut()
            StorageManager.shared.removeStorageData(key: .currentUser)
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
}
