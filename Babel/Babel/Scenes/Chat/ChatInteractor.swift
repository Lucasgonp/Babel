import Foundation
import RealmSwift

protocol ChatInteracting: AnyObject {
    func loadChatMessages()
    func sendMessage(message: OutgoingMessage)
    func refreshNewMessages()
    func updateTypingObserver()
    func didTapOnBackButton()
    func didTapOnContactInfo()
    func registerObservers()
    func removeListeners()
    
    var allLocalMessages: Results<LocalMessage>? { get }
    var displayingMessagesCount: Int { get }
    var maxMessageNumber: Int { get }
    var minMessageNumber: Int { get }
}

final class ChatInteractor {
    typealias Localizable = Strings.ChatView
    
    private let service: ChatServicing
    private let presenter: ChatPresenting
    private let dto: ChatDTO
    private let currentUser = UserSafe.shared.user
    private var notificationToken: NotificationToken?
    
    private var typingCounter = 0
    
    private(set) var allLocalMessages: Results<LocalMessage>?
    private(set) var displayingMessagesCount = 0
    private(set) var maxMessageNumber = 0
    private(set) var minMessageNumber = 0
    
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
            guard let self else { return }
            switch changes {
            case .initial:
                self.insertMessages()
            case let .update(_, _, insertions, _):
                for index in insertions {
                    self.insertMessage(self.allLocalMessages![index])
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
        localMessage.status = Localizable.sent
        
        if let text = message.text {
            sendTextMessage(message: localMessage, text: text, memberIds: message.memberIds)
        }
        
        // TODO: Send push notification
        
        updateRecents(chatRoomId: dto.chatId, lastMessage: localMessage.message)
    }
    
    func refreshNewMessages() {
        if displayingMessagesCount < allLocalMessages?.count ?? 0 {
            loadMoreMessages(maxNumber: maxMessageNumber, minNumber: minMessageNumber)
            presenter.refreshNewMessages()
        } else {
            presenter.endRefreshing()
        }
    }
    
    func updateTypingObserver() {
        typingCounter += 1
        service.saveTypingCounter(isTyping: true, chatRoomId: dto.chatId)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.typingCounterStop()
        }
    }
    
    func removeListeners() {
        service.removeListeners()
    }
    
    func didTapOnBackButton() {
        presenter.didNextStep(action: .popViewController)
    }
    
    func didTapOnContactInfo() {
        presenter.didNextStep(action: .showContactInfo(dto.recipientId))
    }
    
    func registerObservers() {
        listenForNewChats()
        createTypingObserver()
        listenForReadStatusChange()
    }
}

private extension ChatInteractor {
    func listenForNewChats() {
        let date = allLocalMessages?.last?.date ?? Date()
        let lastMessageDate = Calendar.current.date(byAdding: .second, value: 1, to: date) ?? date
        service.listenForNewChats(documentId: currentUser.id, collectionId: dto.chatId, lastMessageDate: lastMessageDate) { [weak self] result in
            switch result {
            case let .success(message):
                
                if message.senderId != self?.currentUser.id {
                    RealmManager.shared.saveToRealm(message)
                }
                
            case let .failure(error):
                print("Error listening to chat: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func createTypingObserver() {
        service.createTypingObserver(chatRoomId: dto.chatId) { [weak self] isTyping in
            DispatchQueue.main.async { [weak self] in
                self?.presenter.updateTypingIndicator(isTyping)
            }
        }
    }
    
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
        guard let allLocalMessages else { return }
        
        maxMessageNumber = (allLocalMessages.count) - displayingMessagesCount
        minMessageNumber = maxMessageNumber - kNUMBEROFMESSAGES
        
        if minMessageNumber < 0 {
            minMessageNumber = 0
        }
        
        for i in minMessageNumber ..< maxMessageNumber {
            insertMessage(allLocalMessages[i])
        }
    }
    
    //MARK: Read message
    func listenForReadStatusChange() {
        service.listenForReadStatusChange(currentUser.id, collectionId: dto.chatId) { [weak self] updatedMessage in
            if updatedMessage.status != Localizable.sent {
                self?.resetUnreadCount()
                self?.presenter.updateMessage(updatedMessage)
            }
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
    
    func loadMoreMessages(maxNumber: Int, minNumber: Int) {
        maxMessageNumber = minNumber - 1
        minMessageNumber = maxMessageNumber - kNUMBEROFMESSAGES
        
        if minMessageNumber < 0 {
            minMessageNumber = 0
        }
        
        for i in (minMessageNumber ... maxMessageNumber).reversed() {
            displayingMessagesCount += 1
            presenter.displayRefreshedMessages(allLocalMessages![i])
        }
    }
    
    func insertMessage(_ localMessage: LocalMessage) {
        if localMessage.senderId != currentUser.id && localMessage.status != Localizable.read {
            markMessageAsRead(localMessage)
        }
        
        displayingMessagesCount += 1
        presenter.displayMessage(localMessage)
    }
    
    func markMessageAsRead(_ localMessage: LocalMessage) {
        service.updateMessageInFirebase(
            message: localMessage,
            dto: .init(
                chatRoomId: dto.chatId,
                messageId: localMessage.id,
                memberIds: [currentUser.id, dto.recipientId],
                status: [kSTATUS: Localizable.read, kREADDATE: Date()]
            )
        )
    }
    
    func typingCounterStop() {
        typingCounter -= 1
        if typingCounter == .zero {
            service.saveTypingCounter(isTyping: false, chatRoomId: dto.chatId)
        }
    }
    
    func updateRecents(chatRoomId: String, lastMessage: String) {
        service.getRecentChats(chatRoomId: chatRoomId) { [weak self] recents in
            for recent in recents {
                self?.updateRecentItemWithNewMessage(recent: recent, lastMessage: lastMessage)
            }
        }
    }
    
    func updateRecentItemWithNewMessage(recent: RecentChatModel, lastMessage: String) {
        var tempRecent = recent
        if tempRecent.senderId != UserSafe.shared.user.id {
            tempRecent.unreadCounter += 1
        }
        
        tempRecent.lastMassage = lastMessage
        tempRecent.date = Date()
        
        ChatHelper.shared.saveRecent(id: tempRecent.id, recentChat: tempRecent)
    }
    
    func resetUnreadCount() {
        service.getRecentChats(chatRoomId: dto.chatId) { recents in
            for recent in recents {
                var recent = recent
                if recent.senderId != UserSafe.shared.user.id {
                    recent.unreadCounter = 0
                }
                
                ChatHelper.shared.saveRecent(id: recent.id, recentChat: recent)
            }
        }
    }
}
