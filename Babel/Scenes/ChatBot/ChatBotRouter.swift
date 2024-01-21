import UIKit

enum ChatBotAction {
    // template
}

protocol ChatBotRouterProtocol: AnyObject {
    func perform(action: ChatBotAction)
}

final class ChatBotRouter {
    weak var viewController: UIViewController?
}

extension ChatBotRouter: ChatBotRouterProtocol {
    func perform(action: ChatBotAction) {
        // template
    }
}
