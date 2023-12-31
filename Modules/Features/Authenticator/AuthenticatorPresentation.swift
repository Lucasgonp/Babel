import UIKit
import FirebaseAuth
import DesignKit

public protocol AuthPresentationProtocol {
    func presentRegister(from navigation: UINavigationController, completion: (() -> Void)?)
    func presentLogin(from navigation: UINavigationController, completion: (() -> Void)?)
    func presentLogin(from tabBar: UITabBarController, completion: (() -> Void)?)
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
    
    public func presentLogin(from tabBar: UITabBarController, completion: (() -> Void)?) {
        let login = LoginFactory.make(completion: completion)
        let loginNav = UINavigationController(rootViewController: login)
        loginNav.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            tabBar.present(loginNav, animated: false)
        }
    }
}
