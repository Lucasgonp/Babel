import UIKit

enum CreateGroupAction {
    // template
}

protocol CreateGroupRouting: AnyObject {
    func perform(action: CreateGroupAction)
}

final class CreateGroupRouter {
    weak var viewController: UIViewController?
}

// MARK: - CreateGroupRouting
extension CreateGroupRouter: CreateGroupRouting {
    func perform(action: CreateGroupAction) {
        // template
    }
}
