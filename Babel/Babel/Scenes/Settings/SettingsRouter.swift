import UIKit
import Authenticator

enum SettingsAction {
    case logout
}

protocol SettingsRouting: AnyObject {
    func perform(action: SettingsAction)
}

final class SettingsRouter {
    weak var viewController: UIViewController?
    weak var delegate: HomeViewDelegate?
}

// MARK: - SettingsRouting
extension SettingsRouter: SettingsRouting {
    func perform(action: SettingsAction) {        
        if case .logout = action {
            delegate?.logout()
        }
    }
}
