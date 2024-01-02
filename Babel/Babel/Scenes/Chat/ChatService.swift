import NetworkKit

protocol ChatServicing {
    func listenForNewChats(documentId: String, collectionId: String, lastMessageDate: Date, completion: @escaping (Result<LocalMessage, FirebaseError>) -> Void)
    func getOldChats(documentId: String, collectionId: String, completion: @escaping (Result<[LocalMessage], FirebaseError>) -> Void)
    func addMessage(_ message: LocalMessage, memberId: String)
    func createTypingObserver(chatRoomId: String, completion: @escaping (_ isTyping: Bool) -> Void)
    func saveTypingCounter(isTyping: Bool, chatRoomId: String)
    func removeListeners()
    func getRecentChats(chatRoomId: String, completion: @escaping (_ recents: [RecentChatModel]) -> Void)
    func updateMessageInFirebase(message: LocalMessage, dto: ChatMessageDTO)
    func listenForReadStatusChange(_ documentId: String, collectionId: String, completion: @escaping (_ localMessage: LocalMessage) -> Void)
}

final class ChatService {
    typealias ChatClientProtocol = FirebaseMessageProtocol &
                                   FirebaseTypingProtocol
    
    private let currentUser = UserSafe.shared.user
    private let client: ChatClientProtocol
    
    init(client: ChatClientProtocol) {
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
    
    func createTypingObserver(chatRoomId: String, completion: @escaping (_ isTyping: Bool) -> Void) {
        client.createTypingObserver(chatRoomId: chatRoomId, currentUserId: currentUser.id, completion: completion)
    }
    
    func saveTypingCounter(isTyping: Bool, chatRoomId: String) {
        client.saveTypingCounter(isTyping: isTyping, chatRoomId: chatRoomId, currentUserId: currentUser.id)
    }
    
    func removeListeners() {
        client.removeListeners()
    }
    
    func getRecentChats(chatRoomId: String, completion: @escaping (_ recents: [RecentChatModel]) -> Void) {
        client.getRecentChatsFrom(chatRoomId: chatRoomId, completion: completion)
    }
    
    func updateMessageInFirebase(message: LocalMessage, dto: ChatMessageDTO) {
        client.updateMessageInFirebase(message: message, dto: dto)
    }
    
    func listenForReadStatusChange(_ documentId: String, collectionId: String, completion: @escaping (_ localMessage: LocalMessage) -> Void) {
        client.listenForReadStatusChange(documentId, collectionId: collectionId, completion: completion)
    }
}
