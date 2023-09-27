import UIKit

enum RecentChatsAction {
    case pushToAllUsersView
    case pushToChatView(dto: ChatDTO)
}

protocol RecentChatsRouting: AnyObject {
    func perform(action: RecentChatsAction)
}

final class RecentChatsRouter {
    weak var viewController: UIViewController?
}

// MARK: - RecentChatsRouting
extension RecentChatsRouter: RecentChatsRouting {
    func perform(action: RecentChatsAction) {
        switch action {
        case .pushToAllUsersView:
            let usersController = UsersFactory.make()
            viewController?.navigationController?.pushViewController(usersController, animated: true) {
//                usersController.navigationItem.largeTitleDisplayMode = .never
//                usersController.navigationController?.navigationBar.prefersLargeTitles = false
            }
        case .pushToChatView(let dto):
            let chatController = ChatFactory.make(dto: dto)
            chatController.hidesBottomBarWhenPushed = true
            viewController?.navigationController?.pushViewController(chatController, animated: true)
        }
    }
}
