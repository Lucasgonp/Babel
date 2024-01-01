protocol ChatPresenting: AnyObject {
    func displayMessage(_ localMessage: LocalMessage)
    func displayRefreshedMessages(_ refreshedMessege: LocalMessage)
    func refreshNewMessages()
    func endRefreshing()
    func updateTypingIndicator(_ isTyping: Bool)
    func didNextStep(action: ChatAction)
}

final class ChatPresenter {
    private let router: ChatRouting
    weak var viewController: ChatDisplaying?

    init(router: ChatRouting) {
        self.router = router
    }
}

// MARK: - ChatPresenting
extension ChatPresenter: ChatPresenting {
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
    
    func didNextStep(action: ChatAction) {
        router.perform(action: action)
    }
}
