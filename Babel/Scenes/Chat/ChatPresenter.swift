protocol ChatPresenterProtocol: AnyObject {
    func displayMessage(_ localMessage: LocalMessage)
    func displayRefreshedMessages(_ refreshedMessege: LocalMessage)
    func refreshNewMessages()
    func updateTypingIndicator(_ isTyping: Bool)
    func updateMessage(_ localMessage: LocalMessage)
    func audioNotGranted()
    func setLoading(_ show: Bool)
    func endRefreshing()
    func didNextStep(action: ChatAction)
}

final class ChatPresenter {
    private let router: ChatRouterProtocol
    weak var viewController: ChatDisplaying?

    init(router: ChatRouterProtocol) {
        self.router = router
    }
}

// MARK: - ChatPresenterProtocol
extension ChatPresenter: ChatPresenterProtocol {
    func displayMessage(_ localMessage: LocalMessage) {
        viewController?.displayMessage(localMessage)
    }
    
    func displayRefreshedMessages(_ refreshedMessege: LocalMessage) {
        viewController?.displayRefreshedMessages(refreshedMessege)
    }
    
    func refreshNewMessages() {
        viewController?.refreshNewMessages()
    }
    
    func updateTypingIndicator(_ isTyping: Bool) {
        viewController?.updateTypingIndicator(isTyping)
    }
    
    func updateMessage(_ localMessage: LocalMessage) {
        viewController?.updateMessage(localMessage)
    }
    
    func audioNotGranted() {
        viewController?.audioNotGranted()
    }
    
    func setLoading(_ show: Bool) {
        viewController?.setLoading(show)
    }
    
    func endRefreshing() {
        viewController?.endRefreshing()
    }
    
    func didNextStep(action: ChatAction) {
        router.perform(action: action)
    }
}
