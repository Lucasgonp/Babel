import NetworkKit

protocol RecentChatsServicing {
    func downloadRecentChats(key: String, currentUserId: String, completion: @escaping ([RecentChatModel]) -> Void)
}

final class RecentChatsService {
    private let client: DownloadRecentChatProtocol
    
    init(client: DownloadRecentChatProtocol) {
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
}
