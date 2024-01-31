import NetworkKit

protocol RecentChatsWorkerProtocol {
    func downloadRecentChats(key: String, currentUserId: String, completion: @escaping ([RecentChatModel]) -> Void)
    func deleteRecentChat(_ chat: RecentChatModel)
    func updateRecentChat(_ chat: RecentChatModel)
    func fetchGroup(from id: String, completion: @escaping (Result<Group, FirebaseError>) -> Void)
}

final class RecentChatsWorker {
    private let client: RecentChatClientProtocol
    
    init(client: RecentChatClientProtocol = FirebaseClient.shared) {
        self.client = client
    }
}

extension RecentChatsWorker: RecentChatsWorkerProtocol {
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
        //TODO: Remove remote chat?
    }
    
    func updateRecentChat(_ chat: RecentChatModel) {
        client.updateRecentChat(id: chat.id, recentChat: chat)
    }
    
    func fetchGroup(from id: String, completion: @escaping (Result<Group, FirebaseError>) -> Void) {
        client.downloadRecentGroup(id: id, completion: completion)
    }
}
