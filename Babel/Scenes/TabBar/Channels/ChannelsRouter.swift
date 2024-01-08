import UIKit

enum ChannelsAction {
    // template
}

protocol ChannelsRouting: AnyObject {
    func perform(action: ChannelsAction)
}

final class ChannelsRouter {
    weak var viewController: UIViewController?
}

// MARK: - ChannelsRouting
extension ChannelsRouter: ChannelsRouting {
    func perform(action: ChannelsAction) {
        // template
    }
}
