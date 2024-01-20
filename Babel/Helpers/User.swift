import Authenticator

typealias User = Authenticator.User
typealias AccountInfo = Authenticator.AccountInfo

struct UserSafe {
    static let shared = UserSafe()
    
    var user: User { AccountInfo.shared.user! }
    let firebaseUser = AccountInfo.shared.firebaseUser!
    
    private init() { }
}
