import UIKit

enum ChatAction {
    case popViewController
    case showContactInfo(String)
}

protocol ChatRouterProtocol: AnyObject {
    func perform(action: ChatAction)
}

final class ChatRouter {
    weak var viewController: UIViewController?
}

// MARK: - ChatRouterProtocol
extension ChatRouter: ChatRouterProtocol {
    func perform(action: ChatAction) {
        switch action {
        case .popViewController:
            viewController?.navigationController?.popViewController(animated: true)
        case let .showContactInfo(contactUserId):
            let controller = ContactInfoFactory.make(contactUserId: contactUserId, shouldDisplayStartChat: false)
            viewController?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
