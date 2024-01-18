import UIKit

enum UsersAction {
    // template
}

protocol UsersRouterProtocol: AnyObject {
    func perform(action: UsersAction)
}

final class UsersRouter {
    weak var viewController: UIViewController?
}

// MARK: - UsersRouterProtocol
extension UsersRouter: UsersRouterProtocol {
    func perform(action: UsersAction) {
        // template
    }
}
