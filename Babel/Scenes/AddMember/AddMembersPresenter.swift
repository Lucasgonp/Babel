protocol AddMembersPresenting: AnyObject {
    func displayViewState(_ state: AddMembersViewState)
    func didNextStep(action: AddMembersAction)
}

final class AddMembersPresenter {
    private let router: AddMembersRouting
    weak var viewController: AddMembersDisplaying?

    init(router: AddMembersRouting) {
        self.router = router
    }
}

extension AddMembersPresenter: AddMembersPresenting {
    func displayViewState(_ state: AddMembersViewState) {
        viewController?.displayViewState(state)
    }
    
    func didNextStep(action: AddMembersAction) {
        router.perform(action: action)
    }
}
