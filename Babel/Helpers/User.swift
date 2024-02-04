import Authenticator

typealias User = Authenticator.User
typealias AccountInfo = Authenticator.AccountInfo

struct UserSafe {
    static let shared = UserSafe()
    
    var user: User { AccountInfo.shared.user! }
    var firebaseUser: FireUser? { AccountInfo.shared.firebaseUser }
    
    private init() { }
}

func removeCurrentUsersFrom(usersIds: [String]) -> [String] {
    usersIds.filter({ $0 != AccountInfo.shared.user?.id })
}
