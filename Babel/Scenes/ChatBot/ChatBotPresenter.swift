protocol ChatBotPresenterProtocol: AnyObject {
    func displayMessage(_ localMessage: LocalMessage)
    func updateTypingIndicator(_ isTyping: Bool)
    func didNextStep(action: ChatBotAction)
}

final class ChatBotPresenter {
    private let router: ChatBotRouterProtocol
    weak var viewController: ChatBotDisplaying?

    init(router: ChatBotRouterProtocol) {
        self.router = router
    }
}

extension ChatBotPresenter: ChatBotPresenterProtocol {
    func displayMessage(_ localMessage: LocalMessage) {
        viewController?.displayMessage(localMessage)
    }
    
    func updateTypingIndicator(_ isTyping: Bool) {
        viewController?.updateTypingIndicator(isTyping)
    }
    
    func didNextStep(action: ChatBotAction) {
        router.perform(action: action)
    }
}
