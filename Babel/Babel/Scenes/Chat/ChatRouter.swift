import UIKit

enum ChatAction {
    case popViewController
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
        if case .popViewController = action {
            viewController?.navigationController?.popViewController(animated: true)
        }
    }
}
