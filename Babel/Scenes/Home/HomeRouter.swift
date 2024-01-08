import UIKit
import Authenticator

enum HomeAction {
    case presentLogin
}

protocol HomeRouting: AnyObject {
    func perform(action: HomeAction)
}

final class HomeRouter {
    weak var viewController: UIViewController?
    private let authPresentation: AuthPresentationProtocol
    
    init(authPresentation: AuthPresentationProtocol) {
        self.authPresentation = authPresentation
    }
}

extension HomeRouter: HomeRouting {
    func perform(action: HomeAction) {
        guard let tabBar = self.viewController as? UITabBarController else {
            return
        }
        
        if case .presentLogin = action {
            authPresentation.presentLogin(from: tabBar) { [weak self] in
                guard let delegate = self?.viewController as? HomeViewDelegate else {
                    return
                }
                
                delegate.reloadData()
            }
        }
    }
}

