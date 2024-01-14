import UIKit

enum ContactInfoAction {
    case pushChatView(dto: ChatDTO)
}

protocol ContactInfoRouting: AnyObject {
    func perform(action: ContactInfoAction)
}

final class ContactInfoRouter {
    weak var viewController: UIViewController?
}

extension ContactInfoRouter: ContactInfoRouting {
    func perform(action: ContactInfoAction) {
        if case .pushChatView(let dto) = action {
            let chatController = ChatFactory.make(dto: dto)
            chatController.hidesBottomBarWhenPushed = true
            viewController?.navigationController?.popViewController(animated: true) { navigation in
                navigation?.pushViewController(chatController, animated: true)
            }
        }
    }
}
