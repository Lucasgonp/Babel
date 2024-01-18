protocol TellAFriendPresenterProtocol: AnyObject {
    func displaySomething()
    func didNextStep(action: TellAFriendAction)
}

final class TellAFriendPresenter {
    private let router: TellAFriendRouterProtocol
    weak var viewController: TellAFriendDisplaying?

    init(router: TellAFriendRouterProtocol) {
        self.router = router
    }
}

// MARK: - TellAFriendPresenterProtocol
extension TellAFriendPresenter: TellAFriendPresenterProtocol {
    func displaySomething() {
        viewController?.displaySomething()
    }
    
    func didNextStep(action: TellAFriendAction) {
        router.perform(action: action)
    }
}
