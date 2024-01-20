import UIKit

enum SystemSettingsAction {
    case popViewController
}

protocol SystemSettingsRouterProtocol: AnyObject {
    func perform(action: SystemSettingsAction)
}

final class SystemSettingsRouter {
    weak var viewController: UIViewController?
}

extension SystemSettingsRouter: SystemSettingsRouterProtocol {
    func perform(action: SystemSettingsAction) {
        if case .popViewController = action {
            viewController?.navigationController?.popViewController(animated: true)
        }
    }
}
