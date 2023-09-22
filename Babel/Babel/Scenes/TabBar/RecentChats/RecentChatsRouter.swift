import UIKit

enum RecentChatsAction {
    // template
}

protocol RecentChatsRouting: AnyObject {
    func perform(action: RecentChatsAction)
}

final class RecentChatsRouter {
    weak var viewController: UIViewController?
}

// MARK: - RecentChatsRouting
extension RecentChatsRouter: RecentChatsRouting {
    func perform(action: RecentChatsAction) {
        // template
    }
}
