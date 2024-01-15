import UIKit

enum GroupInfoAction {
    case didExitGroup
}

protocol GroupInfoRouting: AnyObject {
    func perform(action: GroupInfoAction)
}

final class GroupInfoRouter {
    weak var viewController: UIViewController?
}

extension GroupInfoRouter: GroupInfoRouting {
    func perform(action: GroupInfoAction) {
        if case .didExitGroup = action {
            viewController?.navigationController?.popViewController(animated: true)
        }
    }
}
