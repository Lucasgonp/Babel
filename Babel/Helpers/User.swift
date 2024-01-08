import Authenticator

typealias User = Authenticator.User
typealias AccountInfo = Authenticator.AccountInfo

struct UserSafe {
    static let shared = UserSafe()
    
    let user = AccountInfo.shared.user!
    let firebaseUser = AccountInfo.shared.firebaseUser!
    
    private init() { }
}
