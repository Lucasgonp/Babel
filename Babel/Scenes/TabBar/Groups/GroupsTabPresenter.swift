protocol GroupsTabPresenting: AnyObject {
    func displaySomething()
    func didNextStep(action: GroupsTabAction)
}

final class GroupsTabPresenter {
    private let router: GroupsTabRouting
    weak var viewController: GroupsTabDisplaying?

    init(router: GroupsTabRouting) {
        self.router = router
    }
}

// MARK: - GroupsTabPresenting
extension GroupsTabPresenter: GroupsTabPresenting {
    func displaySomething() {
        viewController?.displaySomething()
    }
    
    func didNextStep(action: GroupsTabAction) {
        router.perform(action: action)
    }
}
