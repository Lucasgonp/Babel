import Foundation
import RealmSwift

protocol ChatBotInteractorProtocol: AnyObject {
    func loadChatMessages()
    func sendMessage(_ message: OutgoingMessage)
    func refreshNewMessages()
    func didTapOnContactInfo()
    func listenForNewChats()
    func removeListeners()
}

final class ChatBotInteractor {
    private let presenter: ChatBotPresenterProtocol
    private var dto: ChatBotDTO
    
    private var currentUser: User {
        UserSafe.shared.user
    }
    
    var viewModel: ChatBotViewModel!
    
    private var notificationToken: NotificationToken?
    
    // Workers
    private let messageWorker: ChatBotMessageWorkerProtocol
    private let openAIWorker: ChatBotAIWorkerProtocol
    
    init(
        presenter: ChatBotPresenterProtocol,
        dto: ChatBotDTO,
        messageWorker: ChatBotMessageWorkerProtocol = ChatBotMessageWorker(),
        openAIWorker: ChatBotAIWorkerProtocol = ChatBotAIWorker()
    ) {
        self.presenter = presenter
        self.dto = dto
        self.messageWorker = messageWorker
        self.openAIWorker = openAIWorker
    }
}

extension ChatBotInteractor: ChatBotInteractorProtocol {
    func loadChatMessages() {
        let predicate = NSPredicate(format: "chatRoomId = %@", dto.chatId)
        viewModel.allLocalMessages = RealmManager.shared.realm.objects(LocalMessage.self).filter(predicate).sorted(byKeyPath: kDATE, ascending: true)
        
        notificationToken = viewModel.allLocalMessages?.observe({ [weak self] (changes: RealmCollectionChange) in
            guard let self else { return }
            switch changes {
            case .initial:
                self.insertMessages()
            case let .update(_, _, insertions, _):
                for index in insertions {
                    self.insertMessage(self.viewModel.allLocalMessages![index])
                }
            case let .error(error):
                fatalError("Error on new insertion \(error.localizedDescription)")
            }
        })
    }
    
    func sendMessage(_ message: OutgoingMessage) {
        let localMessage = LocalMessage()
        localMessage.id = UUID().uuidString
        localMessage.chatRoomId = message.chatId
        localMessage.senderId = currentUser.id
        localMessage.senderName = currentUser.name
        localMessage.date = Date()
        localMessage.type = ChatMessageType.text.rawValue
        
        guard let text = message.text else { return }
        
        presenter.updateTypingIndicator(true)
        sendTextMessage(message: localMessage, text: text)
        
        DispatchQueue.global().async { [weak self] in
            self?.openAIWorker.sendMessage(text) { [weak self] result in
                switch result {
                case let .success(text):
                    DispatchQueue.main.async {
                        self?.presenter.updateTypingIndicator(false)
                        self?.handleBotAnswer(text)
                    }
                case let .failure(error):
                    //TODO
                    print("error: \(error)")
                    break
                }
            }
        }
    }
    
    func refreshNewMessages() {
        
    }
    
    func didTapOnContactInfo() {
        
    }
    
    func listenForNewChats() {
        let date = viewModel.allLocalMessages?.last?.date ?? Date()
        let lastMessageDate = Calendar.current.date(byAdding: .second, value: 1, to: date) ?? date
        messageWorker.listenForNewChats(chatRoomId: dto.chatId, lastMessageDate: lastMessageDate) { result in
            switch result {
            case let .success(message):
                print("successeded: \(message.message)")
            case let .failure(error):
                print("Error listening to chat: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func removeListeners() {
        messageWorker.removeListeners()
    }
}

private extension ChatBotInteractor {
    func sendTextMessage(message: LocalMessage, text: String) {
        message.message = text
        messageWorker.addMessage(message)
    }
    
    func handleBotAnswer(_ text: String) {
        let localMessage = LocalMessage()
        localMessage.id = UUID().uuidString
        localMessage.chatRoomId = dto.chatId
        localMessage.senderId = dto.id
        localMessage.senderName = dto.name
        localMessage.date = Date()
        
        sendTextMessage(message: localMessage, text: text)
    }
    
    func insertMessages() {
        guard let allLocalMessages = viewModel.allLocalMessages else { return }
        
        viewModel.maxMessageNumber = (allLocalMessages.count) - viewModel.displayingMessagesCount
        viewModel.minMessageNumber = viewModel.maxMessageNumber - kNUMBEROFMESSAGES
        
        if viewModel.minMessageNumber < 0 {
            viewModel.minMessageNumber = 0
        }
        
        for i in viewModel.minMessageNumber ..< viewModel.maxMessageNumber {
            insertMessage(allLocalMessages[i])
        }
    }
    
    func insertMessage(_ localMessage: LocalMessage) {
        viewModel.displayingMessagesCount += 1
        presenter.displayMessage(localMessage)
    }
}
