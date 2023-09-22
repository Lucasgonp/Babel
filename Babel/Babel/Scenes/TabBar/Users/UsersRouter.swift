import UIKit

enum UsersAction {
    // template
}

protocol UsersRouting: AnyObject {
    func perform(action: UsersAction)
}

final class UsersRouter {
    weak var viewController: UIViewController?
}

// MARK: - UsersRouting
extension UsersRouter: UsersRouting {
    func perform(action: UsersAction) {
        // template
    }
}
