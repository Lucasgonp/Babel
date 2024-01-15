import UIKit

enum ChatGroupAction {
    // template
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
        // template
    }
}
