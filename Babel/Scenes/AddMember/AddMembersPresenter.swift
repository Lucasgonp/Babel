protocol AddMembersPresenterProtocol: AnyObject {
    func displayViewState(_ state: AddMembersViewState)
    func didNextStep(action: AddMembersAction)
}

final class AddMembersPresenter {
    private let router: AddMembersRouterProtocol
    weak var viewController: AddMembersDisplaying?

    init(router: AddMembersRouterProtocol) {
        self.router = router
    }
}

extension AddMembersPresenter: AddMembersPresenterProtocol {
    func displayViewState(_ state: AddMembersViewState) {
        viewController?.displayViewState(state)
    }
    
    func didNextStep(action: AddMembersAction) {
        router.perform(action: action)
    }
}
