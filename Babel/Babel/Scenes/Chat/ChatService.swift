import NetworkKit

protocol ChatServicing {
    func listenForNewChats(documentId: String, collectionId: String, lastMessageDate: Date, completion: @escaping (Result<LocalMessage, FirebaseError>) -> Void)
    func getOldChats(documentId: String, collectionId: String, completion: @escaping (Result<[LocalMessage], FirebaseError>) -> Void)
    func addMessage(_ message: LocalMessage, memberId: String)
}

final class ChatService {
    private let client: FirebaseMessageProtocol
    
    init(client: FirebaseMessageProtocol) {
        self.client = client
    }
}

// MARK: - ChatServicing
extension ChatService: ChatServicing {
    func listenForNewChats(documentId: String, collectionId: String, lastMessageDate: Date, completion: @escaping (Result<LocalMessage, FirebaseError>) -> Void) {
        client.listenForNewChats(documentId: documentId, collectionId: collectionId, lastMessageDate: lastMessageDate, completion: completion)
    }
    
    func getOldChats(documentId: String, collectionId: String, completion: @escaping (Result<[LocalMessage], FirebaseError>) -> Void) {
        client.getOldChats(documentId: documentId, collectionId: collectionId, completion: completion)
    }
    
    func addMessage(_ message: LocalMessage, memberId: String) {
        client.addMessage(message, memberId: memberId, chatRoomId: message.chatRoomId, messageId: message.id)
    }
}
