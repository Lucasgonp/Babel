import UIKit

enum OpenAIAction {
    case pushChatBot(_ dto: ChatBotDTO)
    case pushImageGenerator(_ dto: ChatBotDTO)
}

protocol OpenAIRouterProtocol: AnyObject {
    func perform(action: OpenAIAction)
}

final class OpenAIRouter {
    weak var viewController: UIViewController?
}

extension OpenAIRouter: OpenAIRouterProtocol {
    func perform(action: OpenAIAction) {
        switch action {
        case let .pushChatBot(dto):
            let controller = ChatBotFactory.make(dto: dto)
            controller.hidesBottomBarWhenPushed = true
            viewController?.navigationController?.pushViewController(controller, animated: true)
        case let .pushImageGenerator(dto):
            let controller = ChatBotFactory.make(dto: dto)
            controller.hidesBottomBarWhenPushed = true
            viewController?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
