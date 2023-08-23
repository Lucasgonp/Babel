protocol UsersPresenting: AnyObject {
    func displaySomething()
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
    func displaySomething() {
        viewController?.displaySomething()
    }
    
    func didNextStep(action: UsersAction) {
        router.perform(action: action)
    }
}
