import NetworkKit

protocol RecentChatsServicing {
    func downloadRecentChats(key: String, currentUserId: String, completion: @escaping ([RecentChatModel]) -> Void)
    func deleteRecentChat(_ chat: RecentChatModel)
    func updateRecentChat(_ chat: RecentChatModel)
}

final class RecentChatsService {
    private let client: RecentChatClientProtocol
    
    init(client: RecentChatClientProtocol) {
        self.client = client
    }
}

// MARK: - RecentChatsServicing
extension RecentChatsService: RecentChatsServicing {
    func downloadRecentChats(key: String, currentUserId: String, completion: @escaping ([RecentChatModel]) -> Void) {
        client.downloadRecentChats(key: key, currentUserId: currentUserId) { (allRecents: [RecentChatModel]) in
            var recentChats = [RecentChatModel]()
            for recent in allRecents {
                if !recent.lastMassage.isEmpty {
                    recentChats.append(recent)
                }
            }
            
            recentChats.sort(by: { $0.date! > $1.date! })
            DispatchQueue.main.async {
                completion(recentChats)
            }
        }
    }
    
    func deleteRecentChat(_ chat: RecentChatModel) {
        client.deleteRecentChat(chat.id)
    }
    
    func updateRecentChat(_ chat: RecentChatModel) {
        client.updateRecentChat(id: chat.id, recentChat: chat)
    }
}
