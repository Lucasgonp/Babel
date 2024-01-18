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
            let controller = GroupInfoFactory.make(groupId: id)
            viewController?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
