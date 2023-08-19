import UIKit
import DesignKit

enum RegisterAction {
    case popToLogin
}

protocol RegisterRouting: AnyObject {
    func perform(action: RegisterAction)
    func popToLogin(title: String, message: String)
}

final class RegisterRouter {
    weak var viewController: UIViewController?
}

// MARK: - RegisterRouting
extension RegisterRouter: RegisterRouting {
    func popToLogin(title: String, message: String) {
        guard let viewController = viewController, let navigation = viewController.navigationController else {
            return
        }
        
        if let loginViewController = navigation.viewControllers.first(where: { $0 is LoginViewController }) {
            navigation.popToViewController(viewController: loginViewController, animated: true) {
                guard let topController = UIApplication.getTopViewController() else {
                   return
                }
                
                guard let controller = topController as? ViewController<LoginInteracting, UIView> else {
                    return
                }
                
                controller.showMessageAlert(title: title, message: message)
            }
        }
    }
    
    func perform(action: RegisterAction) {
        if case .popToLogin = action {
            viewController?.navigationController?.popViewController(animated: true)
        }
    }
}
