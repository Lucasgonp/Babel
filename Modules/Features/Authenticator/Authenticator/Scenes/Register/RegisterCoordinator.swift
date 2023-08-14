import UIKit

enum RegisterAction {
    // template
}

protocol RegisterRouting: AnyObject {
    func perform(action: RegisterAction)
}

final class RegisterRouter {
    weak var viewController: UIViewController?
}

// MARK: - RegisterRouting
extension RegisterRouter: RegisterRouting {
    func perform(action: RegisterAction) {
        // template
    }
}
