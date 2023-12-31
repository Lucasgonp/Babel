import Foundation
import RealmSwift

protocol ChatInteracting: AnyObject {
    func loadChatMessages()
    func listenForNewChats()
    func sendMessage(message: OutgoingMessage)
}

final class ChatInteractor {
    typealias Localizable = Strings.ChatView
    
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
        
        if allLocalMessages?.isEmpty == true {
            checkForOldChats()
        }
        
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
    
    func listenForNewChats() {
        let date = allLocalMessages?.last?.date ?? Date()
        let lastMessageDate = Calendar.current.date(byAdding: .second, value: 1, to: date) ?? date
        service.listenForNewChats(documentId: currentUser.id, collectionId: dto.chatId, lastMessageDate: lastMessageDate) { result in
            switch result {
            case var .success(message):
                RealmManager.shared.saveToRealm(message)
                
            case let .failure(error):
                print("Error listening to chat: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func sendMessage(message: OutgoingMessage) {
        let localMessage = LocalMessage()
        localMessage.id = UUID().uuidString
        localMessage.chatRoomId = message.chatId
        localMessage.senderId = currentUser.id
        localMessage.senderName = currentUser.name
        localMessage.senderInitials = "\(currentUser.username.first!)"
        localMessage.date = Date()
        localMessage.status = Localizable.MessageStatus.sent
        
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
    
    func checkForOldChats() {
        service.getOldChats(documentId: currentUser.id, collectionId: dto.chatId) { result in
            switch result {
            case var .success(messages):
                messages.sort(by: { $0.date < $1.date })
                messages.forEach({ RealmManager.shared.saveToRealm($0) })
                
            case let .failure(error):
                print("Error getting older chat: \(error.localizedDescription)")
                return
            }
        }
    }
}
