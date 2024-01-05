import NetworkKit

protocol SendMessageWorkerProtocol {
    func addMessage(_ message: LocalMessage, memberIds: [String])
    func updateMessageInFirebase(message: LocalMessage, dto: ChatMessageDTO)
}

final class SendMessageWorker {
    private let currentUser = UserSafe.shared.user
    private let client: SendMessageProtocol
    
    init(client: SendMessageProtocol = FirebaseClient.shared) {
        self.client = client
    }
}

extension SendMessageWorker: SendMessageWorkerProtocol {
    func addMessage(_ message: LocalMessage, memberIds: [String]) {
        RealmManager.shared.saveToRealm(message)
        
        for memberId in memberIds {
            client.addMessage(message, memberId: memberId, chatRoomId: message.chatRoomId, messageId: message.id)
        }
    }

func updateMessageInFirebase(message: LocalMessage, dto: ChatMessageDTO) {
    client.updateMessageInFirebase(message: message, dto: dto)
}
}
