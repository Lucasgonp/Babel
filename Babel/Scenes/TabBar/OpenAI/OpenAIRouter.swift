import UIKit

enum OpenAIAction {
    case pushChatBot
    case pushImageGenerator
}

protocol OpenAIRouterProtocol: AnyObject {
    func perform(action: OpenAIAction)
}

final class OpenAIRouter {
    weak var viewController: UIViewController?
}

extension OpenAIRouter: OpenAIRouterProtocol {
    func perform(action: OpenAIAction) {
        //TODO: Open chat bot
    }
}
