protocol ChatGroupPresenting: AnyObject {
    func displayMessage(_ localMessage: LocalMessage)
    func receiveDTO(_ dto: ChatGroupDTO)
    func displayRefreshedMessages(_ refreshedMessege: LocalMessage)
    func refreshNewMessages()
    func endRefreshing()
    func updateTypingIndicator(_ isTyping: Bool)
    func updateMessage(_ localMessage: LocalMessage)
    func didNextStep(action: ChatGroupAction)
}

final class ChatGroupPresenter {
    private let router: ChatGroupRouting
    weak var viewController: ChatGroupDisplaying?

    init(router: ChatGroupRouting) {
        self.router = router
    }
}

extension ChatGroupPresenter: ChatGroupPresenting {
    func displayMessage(_ localMessage: LocalMessage) {
        viewController?.displayMessage(localMessage)
    }
    
    func receiveDTO(_ dto: ChatGroupDTO) {
        viewController?.receiveDTO(dto)
    }
    
    func displayRefreshedMessages(_ refreshedMessege: LocalMessage) {
        viewController?.displayRefreshedMessages(refreshedMessege)
    }
    
    func refreshNewMessages() {
        viewController?.refreshNewMessages()
    }
    
    func endRefreshing() {
        viewController?.endRefreshing()
    }
    
    func updateTypingIndicator(_ isTyping: Bool) {
        viewController?.updateTypingIndicator(isTyping)
    }
    
    func updateMessage(_ localMessage: LocalMessage) {
        viewController?.updateMessage(localMessage)
    }
    
    func didNextStep(action: ChatGroupAction) {
        router.perform(action: action)
    }
}
