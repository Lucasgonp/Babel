import UIKit

enum ContactInfoAction {
    case pushChatView(dto: ChatDTO)
}

protocol ContactInfoRouterProtocol: AnyObject {
    func perform(action: ContactInfoAction)
}

final class ContactInfoRouter {
    weak var viewController: UIViewController?
}

extension ContactInfoRouter: ContactInfoRouterProtocol {
    func perform(action: ContactInfoAction) {
        if case .pushChatView(let dto) = action {
            let chatController = ChatFactory.make(dto: dto)
            chatController.hidesBottomBarWhenPushed = true
            viewController?.navigationController?.pushViewController(chatController, animated: true)
        }
    }
}
