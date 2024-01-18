import Authenticator

protocol SettingsWorkerProtocol {
    func checkAuthentication(completion: @escaping (AuthCheckCredentials?) -> Void)
}

final class SettingsWorker {
    typealias AuthDependencies = CheckAuthenticationProtocol
    
    private let authManager: AuthDependencies
    
    init(authManager: AuthDependencies) {
        self.authManager = authManager
    }
}

extension SettingsWorker: SettingsWorkerProtocol {
    func checkAuthentication(completion: @escaping (AuthCheckCredentials?) -> Void) {
        authManager.checkAuthentication(thread: .main, completion: completion)
    }
}
