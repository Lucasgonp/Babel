import UIKit
import StorageKit
import NetworkKit
import DesignKit

final class CoordinatorManager {
    static let shared = CoordinatorManager()
    private let client: CoordinatorClientProtocol
    
    private var currentUser: User? {
        AccountInfo.shared.user
    }
    
    private init(client: CoordinatorClientProtocol = FirebaseClient.shared) {
        self.client = client
    }
    
    func pushChat(chatRoomId: String) {
        downloadRecentChats(chatRoomId: chatRoomId) { [weak self] result in
            switch result {
            case let .success(recent):
                let currentController = UIApplication.shared.topViewController()
                if let chatController = currentController as? ChatViewController {
                    if chatController.dto.chatId != recent.chatRoomId {
                        currentController?.navigationController?.popViewController(animated: false, completion: { [weak self] navigation in
                            self?.handleToPushChat(navigation: navigation, recent: recent)
                        })
                    }
                } else {
                    if let currentController {
                        self?.handleToPushChat(navigation: currentController.navigationController, recent: recent)
                    } else {
                        StorageLocal.shared.saveStorage(recent, key: kWAITPUSHCHAT)
                    }
                }
            case let .failure(error):
                let currentController = UIApplication.shared.topViewController() as? ViewController<Any, UIView>
                currentController?.showErrorAlert(error.localizedDescription)
                return
            }
        }
    }
    
    func shouldDisplayNotificator(chatRoomId: String) -> Bool {
        let currentController = UIApplication.shared.topViewController()
        if let chatController = currentController as? ChatViewController,
           chatController.dto.chatId == chatRoomId {
            return false
        } else {
            return true
        }
    }
}

private extension CoordinatorManager {
    func downloadRecentChats(chatRoomId: String, completion: @escaping (Result<RecentChatModel, FirebaseError>) -> Void) {
        guard let currentUser else { return }
        client.downloadRecentChat(key: StorageKey.senderId.rawValue, chatRoomId: chatRoomId, currentUserId: currentUser.id) { (result: Result<RecentChatModel, FirebaseError>) in
            switch result {
            case let .success(recent):
                completion(.success(recent))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func downloadGroup(chatRoomId: String, completion: @escaping (Result<Group, FirebaseError>) -> Void) {
        client.downloadGroupWithoutListenner(id: chatRoomId) { (result: Result<Group, FirebaseError>) in
            switch result {
            case let .success(group):
                completion(.success(group))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func handleToPushChat(navigation: UINavigationController?, recent: RecentChatModel) {
        // Uncomment this code if you want to change to recent chats when click on notification
        //        currentController?.tabBarController?.selectedIndex = 0
        ChatHelper.shared.clearUnreadCounter(for: recent)
        
        switch recent.type {
        case .chat:
            pushToChat(navigation: navigation, recent: recent)
        case .group:
            pushToChatGroup(navigation: navigation, recent: recent)
        default:
            return
        }
    }
    
    func pushToChat(navigation: UINavigationController?, recent: RecentChatModel) {
        let dto = ChatDTO(
            chatId: recent.chatRoomId,
            recipientId: recent.receiverId,
            recipientName: recent.receiverName,
            recipientAvatarURL: recent.avatarLink
        )
        let controller = ChatFactory.make(dto: dto)
        controller.hidesBottomBarWhenPushed = true
        navigation?.pushViewController(controller, animated: true)
    }
    
    func pushToChatGroup(navigation: UINavigationController?, recent: RecentChatModel) {
        downloadGroup(chatRoomId: recent.chatRoomId) { result in
            switch result {
            case let .success(group):
                let dto = ChatGroupDTO(chatId: recent.chatRoomId, groupInfo: group, membersIds: group.membersIds)
                let controller = ChatGroupFactory.make(dto: dto)
                controller.hidesBottomBarWhenPushed = true
                navigation?.pushViewController(controller, animated: true)
            case let .failure(error):
                let currentController = UIApplication.shared.topViewController() as? ViewController<Any, UIView>
                currentController?.showErrorAlert(error.localizedDescription)
            }
        }
    }
}
