import NetworkKit

protocol ChatTypingWorkerProtocol {
    func createTypingObserver(chatRoomId: String, completion: @escaping (_ isTyping: Bool) -> Void)
    func saveTypingCounter(isTyping: Bool, chatRoomId: String)
}

final class ChatTypingWorker {
    private let currentUser = UserSafe.shared.user
    private let client: ChatTypingProtocol
    
    init(client: ChatTypingProtocol = FirebaseClient.shared) {
        self.client = client
    }
}

extension ChatTypingWorker: ChatTypingWorkerProtocol {
    func createTypingObserver(chatRoomId: String, completion: @escaping (_ isTyping: Bool) -> Void) {
        client.createTypingObserver(chatRoomId: chatRoomId, currentUserId: currentUser.id, completion: completion)
    }
    
    func saveTypingCounter(isTyping: Bool, chatRoomId: String) {
        client.saveTypingCounter(isTyping: isTyping, chatRoomId: chatRoomId, currentUserId: currentUser.id)
    }
}
