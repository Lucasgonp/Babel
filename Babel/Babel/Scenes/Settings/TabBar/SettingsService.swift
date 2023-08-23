import Authenticator

protocol SettingsServicing {
    func checkAuthentication(completion: @escaping (AuthCheckCredentials?) -> Void)
}

final class SettingsService {
    typealias AuthDependencies = CheckAuthenticationProtocol
    
    private let authManager: AuthDependencies
    
    init(authManager: AuthDependencies) {
        self.authManager = authManager
    }
}

// MARK: - SettingsServicing
extension SettingsService: SettingsServicing {
    func checkAuthentication(completion: @escaping (AuthCheckCredentials?) -> Void) {
        authManager.checkAuthentication(completion: completion)
    }
}
