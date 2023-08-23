import UIKit

enum ChatsAction {
    // template
}

protocol ChatsRouting: AnyObject {
    func perform(action: ChatsAction)
}

final class ChatsRouter {
    weak var viewController: UIViewController?
}

// MARK: - ChatsRouting
extension ChatsRouter: ChatsRouting {
    func perform(action: ChatsAction) {
        // template
    }
}
