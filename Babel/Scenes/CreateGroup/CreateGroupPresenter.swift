protocol CreateGroupPresenting: AnyObject {
    func displayAllUsers(_ users: [User])
    func setLoading(isLoading: Bool)
    func displayErrorMessage(message: String)
    func didNextStep(action: CreateGroupAction)
}

final class CreateGroupPresenter {
    private let router: CreateGroupRouting
    weak var viewController: CreateGroupDisplaying?

    init(router: CreateGroupRouting) {
        self.router = router
    }
}

// MARK: - CreateGroupPresenting
extension CreateGroupPresenter: CreateGroupPresenting {
    func displayAllUsers(_ users: [User]) {
        viewController?.displayAllUsers(users)
    }
    
    func setLoading(isLoading: Bool) {
        viewController?.setLoading(isLoading: isLoading)
    }
    
    func displayErrorMessage(message: String) {
        viewController?.displayErrorMessage(message: message)
    }
    
    func didNextStep(action: CreateGroupAction) {
        router.perform(action: action)
    }
}
