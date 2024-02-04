import StorageKit
import FirebaseAuth

public typealias FireUser = FirebaseAuth.User

public struct AuthCheckCredentials {
    public let user: User
    public let firebaseUser: FirebaseAuth.User
}

public struct AccountInfo {
    public static var shared = AccountInfo()
    
    public var user: User? {
        StorageLocal.shared.getStorageObject(for: .currentUser)
    }
    
    public var firebaseUser: FireUser?
    
    private init() { }
}
