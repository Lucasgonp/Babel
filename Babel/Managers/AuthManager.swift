import Authenticator

struct AuthManager {
    static let shared = AuthenticatorAdapter()
    
    private init() {}
}
