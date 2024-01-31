import StorageKit

protocol RecentChatsInteractorProtocol: AnyObject {
    func loadRecentChats()
    func deleteRecentChat(_ chat: RecentChatModel)
    func didTapOnNewChat()
    func didTapOnChat(_ chat: RecentChatModel)
}

final class RecentChatsInteractor {
    private let service: RecentChatsWorkerProtocol
    private let presenter: RecentChatsPresenterProtocol
    private let currentUser = UserSafe.shared.user
    private var shouldCallNextView = false

    init(service: RecentChatsWorkerProtocol, presenter: RecentChatsPresenterProtocol) {
        self.service = service
        self.presenter = presenter
    }
}

extension RecentChatsInteractor: RecentChatsInteractorProtocol {
    func loadRecentChats() {
        service.downloadRecentChats(key: StorageKey.senderId.rawValue, currentUserId: currentUser.id) { [weak self] recentChats in
            self?.presenter.displayViewState(.success(recentChats: recentChats))
        }
    }
    
    func deleteRecentChat(_ chat: RecentChatModel) {
        service.deleteRecentChat(chat)
    }
    
    func didTapOnNewChat() {
        presenter.didNextStep(action: .pushToAllUsersView)
    }
    
    func didTapOnChat(_ chat: RecentChatModel) {
        ChatHelper.shared.clearUnreadCounter(for: chat)
        
        if chat.type == .chat {
            let dto = ChatDTO(
                chatId: chat.chatRoomId,
                recipientId: chat.receiverId,
                recipientName: chat.receiverName,
                recipientAvatarURL: chat.avatarLink
            )
            presenter.didNextStep(action: .pushToChatView(dto: dto))
        } else {
            shouldCallNextView = true
            service.fetchGroup(from: chat.chatRoomId) { [weak self] result in
                guard let self, self.shouldCallNextView else { return }
                self.shouldCallNextView = false
                
                switch result {
                case let .success(group):
                    let dto = ChatGroupDTO(chatId: chat.chatRoomId, groupInfo: group, membersIds: group.membersIds)
                    self.presenter.didNextStep(action: .pushToGroupChatView(dto: dto))
                case let .failure(error):
                    fatalError("Error on get dto gorup: \(error.localizedDescription)")
                }
            }
        }
    }
}
