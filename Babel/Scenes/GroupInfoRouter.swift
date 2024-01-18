import UIKit

enum GroupInfoAction {
    case didExitGroup
    case pushChatView(dto: ChatGroupDTO)
}

protocol GroupInfoRouterProtocol: AnyObject {
    func perform(action: GroupInfoAction)
}

final class GroupInfoRouter {
    weak var viewController: UIViewController?
}

extension GroupInfoRouter: GroupInfoRouterProtocol {
    func perform(action: GroupInfoAction) {
        switch action {
        case .didExitGroup:
            viewController?.navigationController?.popToRootViewController(animated: true)
        case .pushChatView(let dto):
            let chatGroup = ChatGroupFactory.make(dto: dto)
            viewController?.navigationController?.pushViewController(chatGroup, animated: true)
        }
    }
}
