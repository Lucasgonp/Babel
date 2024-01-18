import UIKit

enum ChatGroupAction {
    case pushGroupInfo(_ group: Group)
}

protocol ChatGroupRouting: AnyObject {
    func perform(action: ChatGroupAction)
}

final class ChatGroupRouter {
    weak var viewController: UIViewController?
}

// MARK: - ChatGroupRouting
extension ChatGroupRouter: ChatGroupRouting {
    func perform(action: ChatGroupAction) {
        if case let .pushGroupInfo(group) = action {
            let controller = GroupInfoFactory.make(groupId: group.id)
        }
    }
}
