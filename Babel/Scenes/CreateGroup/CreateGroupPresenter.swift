protocol CreateGroupPresenterProtocol: AnyObject {
    func displayAllUsers(_ users: [User])
    func setLoading(isLoading: Bool)
    func displayErrorMessage(message: String)
    func didNextStep(action: CreateGroupAction)
}

final class CreateGroupPresenter {
    private let router: CreateGroupRouterProtocol
    weak var viewController: CreateGroupDisplaying?

    init(router: CreateGroupRouterProtocol) {
        self.router = router
    }
}

// MARK: - CreateGroupPresenterProtocol
extension CreateGroupPresenter: CreateGroupPresenterProtocol {
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
