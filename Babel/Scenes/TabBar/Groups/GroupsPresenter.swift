protocol GroupsPresenting: AnyObject {
    func displaySomething()
    func didNextStep(action: GroupsAction)
}

final class GroupsPresenter {
    private let router: GroupsRouting
    weak var viewController: GroupsDisplaying?

    init(router: GroupsRouting) {
        self.router = router
    }
}

// MARK: - GroupsPresenting
extension GroupsPresenter: GroupsPresenting {
    func displaySomething() {
        viewController?.displaySomething()
    }
    
    func didNextStep(action: GroupsAction) {
        router.perform(action: action)
    }
}
