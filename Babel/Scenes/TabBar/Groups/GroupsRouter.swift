import UIKit

enum GroupsAction {
    case pushCreateNewGroup
    case pushGroupInfo(id: String)
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
        switch action {
        case .pushCreateNewGroup:
            let createGroup = CreateGroupFactory.make { [weak self] in
                guard let viewController = self?.viewController as? CreateGroupDelegate else {
                    return
                }
                viewController.didCreateNewGroup()
            }
            createGroup.hidesBottomBarWhenPushed = true
            viewController?.navigationController?.pushViewController(createGroup, animated: true)
        case let .pushGroupInfo(id):
            let groupInfo = GroupInfoFactory.make(groupId: id)
            groupInfo.hidesBottomBarWhenPushed = true
            viewController?.navigationController?.pushViewController(groupInfo, animated: true)
        }
    }
}
