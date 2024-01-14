import UIKit

enum AddMembersAction {
    // template
}

protocol AddMembersRouting: AnyObject {
    func perform(action: AddMembersAction)
}

final class AddMembersRouter {
    weak var viewController: UIViewController?
}

// MARK: - AddMembersRouting
extension AddMembersRouter: AddMembersRouting {
    func perform(action: AddMembersAction) {
        // template
    }
}
