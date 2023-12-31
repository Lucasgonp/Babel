protocol ChatPresenting: AnyObject {
    func displayMessage(_ localMessage: LocalMessage)
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
    
    func didNextStep(action: ChatAction) {
        router.perform(action: action)
    }
}
