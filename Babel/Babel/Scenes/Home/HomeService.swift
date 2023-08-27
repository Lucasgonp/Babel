import NetworkKit
import Authenticator

protocol HomeServicing {
    func checkAuthentication(completion: @escaping (AuthCheckCredentials?) -> Void)
    func logout(completion: @escaping (Error?) -> Void)
}

final class HomeService {
    typealias AuthDependencies = LogoutProtocol & CheckAuthenticationProtocol
    
    private let client: SessionAdapter
    private let authManager: AuthDependencies
    
    init(client: SessionAdapter, authManager: AuthDependencies) {
        self.client = client
        self.authManager = authManager
    }
}

// MARK: - HomeServicing
extension HomeService: HomeServicing {    
    func checkAuthentication(completion: @escaping (AuthCheckCredentials?) -> Void) {
        authManager.checkAuthentication(thread: .main, completion: completion)
    }
    
    func logout(completion: @escaping (Error?) -> Void) {
        authManager.logout(thread: .main, completion: completion)
    }
}
