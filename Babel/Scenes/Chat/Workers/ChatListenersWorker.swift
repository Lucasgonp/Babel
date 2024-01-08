import NetworkKit

protocol ChatListenersWorkerProtocol {
    func listenForNewChats(documentId: String, collectionId: String, lastMessageDate: Date, completion: @escaping (Result<LocalMessage, FirebaseError>) -> Void)
    func createTypingObserver(chatRoomId: String, completion: @escaping (_ isTyping: Bool) -> Void)
    func listenForReadStatusChange(_ documentId: String, collectionId: String, completion: @escaping (_ localMessage: LocalMessage) -> Void)
    func removeListeners()
}

final class ChatListenersWorker {
    private let currentUser = UserSafe.shared.user
    private let client: ChatListenerProtocol
    
    init(client: ChatListenerProtocol = FirebaseClient.shared) {
        self.client = client
    }
}

extension ChatListenersWorker: ChatListenersWorkerProtocol {
    func listenForNewChats(documentId: String, collectionId: String, lastMessageDate: Date, completion: @escaping (Result<LocalMessage, FirebaseError>) -> Void) {
        client.listenForNewChats(documentId: documentId, collectionId: collectionId, lastMessageDate: lastMessageDate, completion: completion)
    }
    
    func createTypingObserver(chatRoomId: String, completion: @escaping (_ isTyping: Bool) -> Void) {
        client.createTypingObserver(chatRoomId: chatRoomId, currentUserId: currentUser.id, completion: completion)
    }
    
    func listenForReadStatusChange(_ documentId: String, collectionId: String, completion: @escaping (_ localMessage: LocalMessage) -> Void) {
        client.listenForReadStatusChange(documentId, collectionId: collectionId, completion: completion)
    }
    
    func removeListeners() {
        client.removeListeners()
    }
}
