protocol GroupsPresenting: AnyObject {
    func displayAllGroups(_ groups: [Group])
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
    func displayAllGroups(_ groups: [Group]) {
        viewController?.displayAllGroups(groups)
    }
    
    func didNextStep(action: GroupsAction) {
        router.perform(action: action)
    }
}
