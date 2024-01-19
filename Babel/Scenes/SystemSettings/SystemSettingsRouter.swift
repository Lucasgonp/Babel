import UIKit

enum SystemSettingsAction {
    case popViewController
}

protocol SystemSettingsRouting: AnyObject {
    func perform(action: SystemSettingsAction)
}

final class SystemSettingsRouter {
    weak var viewController: UIViewController?
}

extension SystemSettingsRouter: SystemSettingsRouting {
    func perform(action: SystemSettingsAction) {
        if case .popViewController = action {
            viewController?.navigationController?.popViewController(animated: true)
        }
    }
}
