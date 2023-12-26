import NetworkKit

protocol ChatServicing {
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
    func addMessage(_ message: LocalMessage, memberId: String) {
        client.addMessage(message, memberId: memberId, chatRoomId: message.chatRoomId, messageId: message.id)
    }
}
