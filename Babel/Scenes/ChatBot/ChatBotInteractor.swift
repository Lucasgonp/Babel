import Foundation

protocol ChatBotInteractorProtocol: AnyObject {
    func loadChatMessages()
    func sendMessage(_ message: OutgoingMessage)
    func refreshNewMessages()
    func didTapOnContactInfo()
}

final class ChatBotInteractor {
    private let worker: ChatBotWorker
    private let presenter: ChatBotPresenterProtocol
    private var dto: ChatBotDTO
    
    weak var viewModel: ChatBotViewModel?
    
    init(worker: ChatBotWorker, presenter: ChatBotPresenterProtocol, dto: ChatBotDTO) {
        self.worker = worker
        self.presenter = presenter
        self.dto = dto
    }
}

extension ChatBotInteractor: ChatBotInteractorProtocol {
    func loadChatMessages() {
        let predicate = NSPredicate(format: "chatRoomId = %@", dto.chatId)
        viewModel?.allLocalMessages = RealmManager.shared.realm.objects(LocalMessage.self).filter(predicate).sorted(byKeyPath: kDATE, ascending: true)
    }
    
    func sendMessage(_ message: OutgoingMessage) {
        
    }
    
    func refreshNewMessages() {
        
    }
    
    func didTapOnContactInfo() {
        
    }
}
