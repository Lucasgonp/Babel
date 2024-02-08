protocol ChatGroupPresenterProtocol: AnyObject {
    func displayMessage(_ localMessage: LocalMessage)
    func displayRefreshedMessages(_ refreshedMessege: LocalMessage)
    func refreshNewMessages()
    func updateTypingIndicator(_ isTyping: Bool)
    func didUpdateGroupInfo(_ groupInfo: Group)
    func updateMessage(_ localMessage: LocalMessage)
    func audioNotGranted()
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
    
    func updateTypingIndicator(_ isTyping: Bool) {
        viewController?.updateTypingIndicator(isTyping)
    }
    
    func didUpdateGroupInfo(_ groupInfo: Group) {
        viewController?.didUpdateGroupInfo(groupInfo)
    }
    
    func updateMessage(_ localMessage: LocalMessage) {
        viewController?.updateMessage(localMessage)
    }
    
    func audioNotGranted() {
        viewController?.audioNotGranted()
    }
    
    func didNextStep(action: ChatGroupAction) {
        router.perform(action: action)
    }
}
