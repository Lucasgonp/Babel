import Authenticator

protocol HomeWorkerProtocol {
    func checkAuthentication(completion: @escaping (AuthCheckCredentials?) -> Void)
    func logout(completion: @escaping (Error?) -> Void)
}

final class HomeWorker {
    typealias AuthDependencies = LogoutProtocol & CheckAuthenticationProtocol
    
    private let client: AuthDependencies
    
    init(client: AuthDependencies) {
        self.client = client
    }
}

extension HomeWorker: HomeWorkerProtocol {    
    func checkAuthentication(completion: @escaping (AuthCheckCredentials?) -> Void) {
        client.checkAuthentication(thread: .main, completion: completion)
    }
    
    func logout(completion: @escaping (Error?) -> Void) {
        client.logout(thread: .main, completion: completion)
    }
}
