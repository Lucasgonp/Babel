protocol GroupInfoPresenting: AnyObject {
    func displayGroup(with groupInfo: Group, members: [User], shouldDisplayStartChat: Bool)
    func displayLoading(isLoading: Bool)
    func displayError(message: String)
    func didNextStep(action: GroupInfoAction)
}

final class GroupInfoPresenter {
    private let router: GroupInfoRouting
    weak var viewController: GroupInfoDisplaying?

    init(router: GroupInfoRouting) {
        self.router = router
    }
}

// MARK: - GroupInfoPresenting
extension GroupInfoPresenter: GroupInfoPresenting {
    func displayGroup(with groupInfo: Group, members: [User], shouldDisplayStartChat: Bool) {
        viewController?.displayViewState(.success(groupInfo: groupInfo, members: members, shouldDisplayStartChat: shouldDisplayStartChat))
    }
    
    func displayLoading(isLoading: Bool) {
        viewController?.displayViewState(.setLoading(isLoading: isLoading))
    }
    
    func displayError(message: String) {
        viewController?.displayViewState(.error(message: message))
    }
    
    func didNextStep(action: GroupInfoAction) {
        router.perform(action: action)
    }
}
