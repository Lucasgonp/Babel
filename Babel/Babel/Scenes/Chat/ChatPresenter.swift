protocol ChatPresenting: AnyObject {
    func displaySomething()
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
    func displaySomething() {
        viewController?.displaySomething()
    }
    
    func didNextStep(action: ChatAction) {
        router.perform(action: action)
    }
}
