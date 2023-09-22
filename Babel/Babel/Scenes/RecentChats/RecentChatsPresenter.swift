protocol RecentChatsPresenting: AnyObject {
    func displaySomething()
    func didNextStep(action: RecentChatsAction)
}

final class RecentChatsPresenter {
    private let router: RecentChatsRouting
    weak var viewController: RecentChatsDisplaying?

    init(router: RecentChatsRouting) {
        self.router = router
    }
}

// MARK: - RecentChatsPresenting
extension RecentChatsPresenter: RecentChatsPresenting {
    func displaySomething() {
        viewController?.displaySomething()
    }
    
    func didNextStep(action: RecentChatsAction) {
        router.perform(action: action)
    }
}
