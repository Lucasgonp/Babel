import Foundation

protocol ChatInteracting: AnyObject {
    func loadSomething()
    func sendMessage(message: OutgoingMessage)
}

final class ChatInteractor {
    private let service: ChatServicing
    private let presenter: ChatPresenting
    private var currentUser: User {
        AccountInfo.shared.user!
    }

    init(service: ChatServicing, presenter: ChatPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - ChatInteracting
extension ChatInteractor: ChatInteracting {
    func loadSomething() {
        presenter.displaySomething()
    }
    
    func sendMessage(message: OutgoingMessage) {
        let localMessage = LocalMessage()
        localMessage.id = UUID().uuidString
        localMessage.chatRoomId = message.chatId
        localMessage.senderId = currentUser.id
        localMessage.senderName = currentUser.name
        localMessage.senderInitials = "\(currentUser.username.first!)"
        localMessage.date = Date()
        localMessage.status = "Sent"
        
        if let text = message.text {
            sendTextMessage(message: localMessage, text: text, memberIds: message.memberIds)
        }
        
        // TODO: Send push notification
        // TODO: Update recent chat
    }
}

private extension ChatInteractor {
    func sendTextMessage(message: LocalMessage, text: String, memberIds: [String]) {
        message.message = text
        message.type = ChatMessageType.text.rawValue
        
        sendMessage(message: message, memberIds: memberIds)
    }
    
    func sendMessage(message: LocalMessage, memberIds: [String]) {
        RealmManager.shared.saveToRealm(message)
        
        for memberId in memberIds {
            print("sabe message for \(memberId)")
        }
    }
}
