protocol ChatGroupPresenterProtocol: AnyObject {
    func displayMessage(_ localMessage: LocalMessage)
    func displayRefreshedMessages(_ refreshedMessege: LocalMessage)
    func refreshNewMessages()
    func endRefreshing()
    func updateTypingIndicator(_ isTyping: Bool)
    func updateMessage(_ localMessage: LocalMessage)
    func didNextStep(action: ChatGroupAction)
}

final class ChatGroupPresenter {
    private let router: ChatGroupRouterProtocol
    weak var viewController: ChatGroupDisplaying?

    init(router: ChatGroupRouterProtocol) {
        self.router = router
    }
}

extension ChatGroupPresenter: ChatGroupPresenterProtocol {
    func displayMessage(_ localMessage: LocalMessage) {
        viewController?.displayMessage(localMessage)
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
