import Authenticator

protocol HomeServicing {
    func checkAuthentication(completion: @escaping (AuthCheckCredentials?) -> Void)
    func logout(completion: @escaping (Error?) -> Void)
}

final class HomeService {
    typealias AuthDependencies = LogoutProtocol & CheckAuthenticationProtocol
    
    private let client: AuthDependencies
    
    init(client: AuthDependencies) {
        self.client = client
    }
}

extension HomeService: HomeServicing {    
    func checkAuthentication(completion: @escaping (AuthCheckCredentials?) -> Void) {
        client.checkAuthentication(thread: .main, completion: completion)
    }
    
    func logout(completion: @escaping (Error?) -> Void) {
        client.logout(thread: .main, completion: completion)
    }
}
