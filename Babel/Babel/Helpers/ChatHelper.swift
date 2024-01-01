import NetworkKit
import StorageKit

final class ChatHelper {
    static let shared = ChatHelper()
    private let client: ChatHelperClientProtocol = FirebaseClient.shared
    private let currentUser = UserSafe.shared.user
    
    private init() {}
    
    func resetRecentCounter(chatRoomId: String) {
        let dto = ChatHelperDTO(
            chatRoomId: chatRoomId,
            chatRoomKey: StorageKey.chatRoomId.rawValue,
            senderKey: StorageKey.senderId.rawValue,
            currentUserId: currentUser.id
        )
        client.resetRecentCounter(dto: dto) { [weak self] (allRecents: [RecentChatModel]) in
            if !allRecents.isEmpty, let firstRecent = allRecents.first {
                self?.clearUnreadCounter(for: firstRecent)
            }
        }
    }
    
    func clearUnreadCounter(for chat: RecentChatModel) {
        var recent = chat
        recent.unreadCounter = 0
        client.saveRecentChat(id: recent.id, recentChat: recent)
    }
}
