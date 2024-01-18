import UIKit

enum TellAFriendAction {
    // template
}

protocol TellAFriendRouterProtocol: AnyObject {
    func perform(action: TellAFriendAction)
}

final class TellAFriendRouter {
    weak var viewController: UIViewController?
}

// MARK: - TellAFriendRouterProtocol
extension TellAFriendRouter: TellAFriendRouterProtocol {
    func perform(action: TellAFriendAction) {
        // template
    }
}
