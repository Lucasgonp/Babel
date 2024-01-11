import UIKit

enum GroupsAction {
    // template
}

protocol GroupsRouting: AnyObject {
    func perform(action: GroupsAction)
}

final class GroupsRouter {
    weak var viewController: UIViewController?
}

// MARK: - GroupsRouting
extension GroupsRouter: GroupsRouting {
    func perform(action: GroupsAction) {
        // template
    }
}
