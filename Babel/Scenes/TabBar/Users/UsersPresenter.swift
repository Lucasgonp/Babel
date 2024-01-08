protocol UsersPresenting: AnyObject {
    func displayViewState(_ state: UsersViewState)
    func didNextStep(action: UsersAction)
}

final class UsersPresenter {
    private let router: UsersRouting
    weak var viewController: UsersDisplaying?

    init(router: UsersRouting) {
        self.router = router
    }
}

// MARK: - UsersPresenting
extension UsersPresenter: UsersPresenting {
    func displayViewState(_ state: UsersViewState) {
        viewController?.displayViewState(state)
    }
    
    func didNextStep(action: UsersAction) {
        router.perform(action: action)
    }
}
