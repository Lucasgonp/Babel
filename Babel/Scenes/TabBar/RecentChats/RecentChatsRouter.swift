import UIKit

enum RecentChatsAction {
    case pushToAllUsersView
    case pushToChatView(dto: ChatDTO)
    case pushToGroupChatView(dto: ChatGroupDTO)
}

protocol RecentChatsRouterProtocol: AnyObject {
    func perform(action: RecentChatsAction)
}

final class RecentChatsRouter {
    weak var viewController: UIViewController?
}

// MARK: - RecentChatsRouterProtocol
extension RecentChatsRouter: RecentChatsRouterProtocol {
    func perform(action: RecentChatsAction) {
        switch action {
        case .pushToAllUsersView:
            let usersController = UsersFactory.make()
            viewController?.navigationController?.pushViewController(usersController, animated: true)
        case .pushToChatView(let dto):
            let chatController = ChatFactory.make(dto: dto)
            chatController.hidesBottomBarWhenPushed = true
            viewController?.navigationController?.pushViewController(chatController, animated: true)
        case let .pushToGroupChatView(dto):
            let chatController = ChatGroupFactory.make(dto: dto)
            chatController.hidesBottomBarWhenPushed = true
            viewController?.navigationController?.pushViewController(chatController, animated: true)
        }
    }
}
