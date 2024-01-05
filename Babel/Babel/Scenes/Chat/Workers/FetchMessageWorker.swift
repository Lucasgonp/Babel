import NetworkKit

protocol FetchMessageWorkerProtocol {
    func getOldChats(documentId: String, collectionId: String, completion: @escaping (Result<[LocalMessage], FirebaseError>) -> Void)
    func getRecentChats(chatRoomId: String, completion: @escaping (_ recents: [RecentChatModel]) -> Void)
}

final class FetchMessageWorker {
    private let currentUser = UserSafe.shared.user
    private let client: FetchMessageProtocol
    
    init(client: FetchMessageProtocol = FirebaseClient.shared) {
        self.client = client
    }
}

extension FetchMessageWorker: FetchMessageWorkerProtocol {
    func getOldChats(documentId: String, collectionId: String, completion: @escaping (Result<[LocalMessage], FirebaseError>) -> Void) {
        client.getOldChats(documentId: documentId, collectionId: collectionId, completion: completion)
    }
    
    func getRecentChats(chatRoomId: String, completion: @escaping (_ recents: [RecentChatModel]) -> Void) {
        client.getRecentChatsFrom(chatRoomId: chatRoomId, completion: completion)
    }
}
