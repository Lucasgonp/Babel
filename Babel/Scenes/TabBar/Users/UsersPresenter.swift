protocol UsersPresenterProtocol: AnyObject {
    func displayViewState(_ state: UsersViewState)
    func didNextStep(action: UsersAction)
}

final class UsersPresenter {
    private let router: UsersRouterProtocol
    weak var viewController: UsersDisplaying?

    init(router: UsersRouterProtocol) {
        self.router = router
    }
}

// MARK: - UsersPresenterProtocol
extension UsersPresenter: UsersPresenterProtocol {
    func displayViewState(_ state: UsersViewState) {
        viewController?.displayViewState(state)
    }
    
    func didNextStep(action: UsersAction) {
        router.perform(action: action)
    }
}
