protocol RecentChatsPresenterProtocol: AnyObject {
    func displayViewState(_ state: RecentChatsViewState)
    func didNextStep(action: RecentChatsAction)
}

final class RecentChatsPresenter {
    private let router: RecentChatsRouterProtocol
    weak var viewController: RecentChatsDisplaying?

    init(router: RecentChatsRouterProtocol) {
        self.router = router
    }
}

// MARK: - RecentChatsPresenterProtocol
extension RecentChatsPresenter: RecentChatsPresenterProtocol {
    func displayViewState(_ state: RecentChatsViewState) {
        viewController?.displayViewState(state)
    }
    
    func didNextStep(action: RecentChatsAction) {
        router.perform(action: action)
    }
}
