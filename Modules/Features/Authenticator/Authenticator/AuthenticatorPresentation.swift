import UIKit
import FirebaseAuth

public protocol AuthPresentationProtocol {
    func presentRegister(from navigation: UINavigationController, completion: (() -> Void)?)
    func presentLogin(from navigation: UINavigationController, completion: (() -> Void)?)
}

public struct AuthenticatorPresentation {
    public static let shared: AuthPresentationProtocol = AuthenticatorPresentation()
}

extension AuthenticatorPresentation: AuthPresentationProtocol {    
    public func presentRegister(from navigation: UINavigationController, completion: (() -> Void)?) {
        let register = RegisterFactory.make()
        navigation.pushViewController(register, animated: true)
    }
    
    public func presentLogin(from navigation: UINavigationController, completion: (() -> Void)?) {
        let login = LoginFactory.make(completion: completion)
        let loginNav = UINavigationController(rootViewController: login)
        loginNav.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            navigation.present(loginNav, animated: false)
        }
    }
}
