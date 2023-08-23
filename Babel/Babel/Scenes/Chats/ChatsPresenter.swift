protocol ChatsPresenting: AnyObject {
    func displaySomething()
    func didNextStep(action: ChatsAction)
}

final class ChatsPresenter {
    private let router: ChatsRouting
    weak var viewController: ChatsDisplaying?

    init(router: ChatsRouting) {
        self.router = router
    }
}

// MARK: - ChatsPresenting
extension ChatsPresenter: ChatsPresenting {
    func displaySomething() {
        viewController?.displaySomething()
    }
    
    func didNextStep(action: ChatsAction) {
        router.perform(action: action)
    }
}
