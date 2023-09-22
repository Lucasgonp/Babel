protocol TellAFriendPresenting: AnyObject {
    func displaySomething()
    func didNextStep(action: TellAFriendAction)
}

final class TellAFriendPresenter {
    private let router: TellAFriendRouting
    weak var viewController: TellAFriendDisplaying?

    init(router: TellAFriendRouting) {
        self.router = router
    }
}

// MARK: - TellAFriendPresenting
extension TellAFriendPresenter: TellAFriendPresenting {
    func displaySomething() {
        viewController?.displaySomething()
    }
    
    func didNextStep(action: TellAFriendAction) {
        router.perform(action: action)
    }
}
