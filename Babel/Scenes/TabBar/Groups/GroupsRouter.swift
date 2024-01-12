import UIKit

enum GroupsAction {
    case pushCreateNewGroup
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
        if case .pushCreateNewGroup = action {
            let createGroup = CreateGroupFactory.make { [weak self] in
                guard let viewController = self?.viewController as? CreateGroupDelegate else {
                    return
                }
                viewController.didCreateNewGroup()
            }
            createGroup.hidesBottomBarWhenPushed = true
            viewController?.navigationController?.pushViewController(createGroup, animated: true)
        }
    }
}
