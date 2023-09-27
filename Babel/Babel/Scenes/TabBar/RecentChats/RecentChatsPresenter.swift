protocol RecentChatsPresenting: AnyObject {
    func displayViewState(_ state: RecentChatsViewState)
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
    func displayViewState(_ state: RecentChatsViewState) {
        viewController?.displayViewState(state)
    }
    
    func didNextStep(action: RecentChatsAction) {
        router.perform(action: action)
    }
}
