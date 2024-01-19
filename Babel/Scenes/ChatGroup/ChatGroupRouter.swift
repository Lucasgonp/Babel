import UIKit

enum ChatGroupAction {
    case pushGroupInfo(_ id: String)
}

protocol ChatGroupRouterProtocol: AnyObject {
    func perform(action: ChatGroupAction)
}

final class ChatGroupRouter {
    weak var viewController: UIViewController?
}

extension ChatGroupRouter: ChatGroupRouterProtocol {
    func perform(action: ChatGroupAction) {
        if case let .pushGroupInfo(id) = action {
            let delegate = viewController as? GroupInfoUpdateProtocol
            let controller = GroupInfoFactory.make(groupId: id, delegate: delegate)
            viewController?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
