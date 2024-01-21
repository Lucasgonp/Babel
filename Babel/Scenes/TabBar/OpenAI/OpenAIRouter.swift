import UIKit

enum OpenAIAction {
    // template
}

protocol OpenAIRouterProtocol: AnyObject {
    func perform(action: OpenAIAction)
}

final class OpenAIRouter {
    weak var viewController: UIViewController?
}

extension OpenAIRouter: OpenAIRouterProtocol {
    func perform(action: OpenAIAction) {
        // template
    }
}
