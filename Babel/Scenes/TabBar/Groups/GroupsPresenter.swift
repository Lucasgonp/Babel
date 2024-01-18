protocol GroupsPresenterProtocol: AnyObject {
    func displayAllGroups(_ groups: [Group])
    func didNextStep(action: GroupsAction)
}

final class GroupsPresenter {
    private let router: GroupsRouterProtocol
    weak var viewController: GroupsDisplaying?

    init(router: GroupsRouterProtocol) {
        self.router = router
    }
}

// MARK: - GroupsPresenterProtocol
extension GroupsPresenter: GroupsPresenterProtocol {
    func displayAllGroups(_ groups: [Group]) {
        viewController?.displayAllGroups(groups)
    }
    
    func didNextStep(action: GroupsAction) {
        router.perform(action: action)
    }
}
