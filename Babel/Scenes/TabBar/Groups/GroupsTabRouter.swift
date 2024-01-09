import UIKit

enum GroupsTabAction {
    // template
}

protocol GroupsTabRouting: AnyObject {
    func perform(action: GroupsTabAction)
}

final class GroupsTabRouter {
    weak var viewController: UIViewController?
}

// MARK: - GroupsTabRouting
extension GroupsTabRouter: GroupsTabRouting {
    func perform(action: GroupsTabAction) {
        // template
    }
}
