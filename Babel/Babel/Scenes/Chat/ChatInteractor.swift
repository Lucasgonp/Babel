import Foundation
import RealmSwift

protocol ChatInteracting: AnyObject {
    func loadChatMessages()
    func sendMessage(message: OutgoingMessage)
}

final class ChatInteractor {
    private let service: ChatServicing
    private let presenter: ChatPresenting
    private let dto: ChatDTO
    private var currentUser: User {
        AccountInfo.shared.user!
    }
    private var allLocalMessages: Results<LocalMessage>?
    private var notificationToken: NotificationToken?

    init(service: ChatServicing, presenter: ChatPresenting, dto: ChatDTO) {
        self.service = service
        self.presenter = presenter
        self.dto = dto
    }
}

// MARK: - ChatInteracting
extension ChatInteractor: ChatInteracting {
    func loadChatMessages() {
        let predicate = NSPredicate(format: "chatRoomId = %@", dto.chatId)
        allLocalMessages = RealmManager.shared.realm.objects(LocalMessage.self).filter(predicate).sorted(byKeyPath: kDATE, ascending: true)
        notificationToken = allLocalMessages?.observe({ [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self?.insertMessages()
            case let .update(_, _, insertions, _):
                for index in insertions {
                    self?.presenter.displayMessage(self!.allLocalMessages![index])
                }
            case let .error(error):
                fatalError("Error on new insertion \(error.localizedDescription)")
            }
        })
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
            service.addMessage(message, memberId: memberId)
        }
    }
    
    func insertMessages() {
        for localMessage in allLocalMessages! {
            presenter.displayMessage(localMessage)
        }
    }
}
