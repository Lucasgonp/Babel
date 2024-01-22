import NetworkKit

protocol ChatBotMessageWorkerProtocol {
    func addMessage(_ message: LocalMessage)
    func listenForNewChats(chatRoomId: String, lastMessageDate: Date, completion: @escaping (Result<LocalMessage, FirebaseError>) -> Void)
    func removeListeners()
}

final class ChatBotMessageWorker {
    private let client: ChatBotProtocol
    
    private var currentUser: User {
        UserSafe.shared.user
    }
    
    init(client: ChatBotProtocol = FirebaseClient.shared) {
        self.client = client
    }
}

extension ChatBotMessageWorker: ChatBotMessageWorkerProtocol {
    func addMessage(_ message: LocalMessage) {
        RealmManager.shared.saveToRealm(message)
        client.addMessageBot(message, currentUserId: currentUser.id, chatRoomId: message.chatRoomId, messageId: message.id)
    }
    
    func listenForNewChats(chatRoomId: String, lastMessageDate: Date, completion: @escaping (Result<LocalMessage, FirebaseError>) -> Void) {
        client.listenForNewChats(documentId: currentUser.id, collectionId: chatRoomId, lastMessageDate: lastMessageDate, completion: completion)
    }
    
    func removeListeners() {
        client.removeListeners()
    }
}
