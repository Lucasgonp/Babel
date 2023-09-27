import StorageKit

protocol RecentChatsInteracting: AnyObject {
    func loadRecentChats()
    func deleteRecentChat(_ chat: RecentChatModel)
    func didTapOnNewChat()
    func didTapOnChat(_ chat: RecentChatModel)
}

final class RecentChatsInteractor {
    private let service: RecentChatsServicing
    private let presenter: RecentChatsPresenting
    private var currentUser: User {
        AccountInfo.shared.user!
    }

    init(service: RecentChatsServicing, presenter: RecentChatsPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - RecentChatsInteracting
extension RecentChatsInteractor: RecentChatsInteracting {
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
        StartChat.shared.restartChat(chatRoomId: chat.chatRoomId, memberIds: chat.membersId)
        let dto = ChatDTO(
            chatId: chat.chatRoomId,
            recipientId: chat.receiverId,
            recipientName: chat.receiverName
        )
        presenter.didNextStep(action: .pushToChatView(dto: dto))
    }
}
