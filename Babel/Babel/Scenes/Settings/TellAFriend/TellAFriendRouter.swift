import UIKit

enum TellAFriendAction {
    // template
}

protocol TellAFriendRouting: AnyObject {
    func perform(action: TellAFriendAction)
}

final class TellAFriendRouter {
    weak var viewController: UIViewController?
}

// MARK: - TellAFriendRouting
extension TellAFriendRouter: TellAFriendRouting {
    func perform(action: TellAFriendAction) {
        // template
    }
}
