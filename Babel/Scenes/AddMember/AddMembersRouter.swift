import UIKit

enum AddMembersAction {
    // template
}

protocol AddMembersRouterProtocol: AnyObject {
    func perform(action: AddMembersAction)
}

final class AddMembersRouter {
    weak var viewController: UIViewController?
}

// MARK: - AddMembersRouterProtocol
extension AddMembersRouter: AddMembersRouterProtocol {
    func perform(action: AddMembersAction) {
        // template
    }
}
