import UIKit

enum GroupInfoAction {
    // template
}

protocol GroupInfoRouting: AnyObject {
    func perform(action: GroupInfoAction)
}

final class GroupInfoRouter {
    weak var viewController: UIViewController?
}

// MARK: - GroupInfoRouting
extension GroupInfoRouter: GroupInfoRouting {
    func perform(action: GroupInfoAction) {
        // template
    }
}
