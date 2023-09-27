import UIKit

enum ChatAction {
    // template
}

protocol ChatRouting: AnyObject {
    func perform(action: ChatAction)
}

final class ChatRouter {
    weak var viewController: UIViewController?
}

// MARK: - ChatRouting
extension ChatRouter: ChatRouting {
    func perform(action: ChatAction) {
        // template
    }
}
