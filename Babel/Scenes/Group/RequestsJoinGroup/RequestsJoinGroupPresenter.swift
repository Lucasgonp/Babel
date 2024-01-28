protocol RequestsJoinGroupPresenterProtocol: AnyObject {
    func displayUsers(_ users: [User])
    func updateRequests(_ id: String)
    func displayError(message: String)
    func didNextStep(action: RequestsJoinGroupAction)
}

final class RequestsJoinGroupPresenter {
    private let router: RequestsJoinGroupRouterProtocol
    weak var viewController: RequestsJoinGroupDisplaying?

    init(router: RequestsJoinGroupRouterProtocol) {
        self.router = router
    }
}

extension RequestsJoinGroupPresenter: RequestsJoinGroupPresenterProtocol {
    func displayUsers(_ users: [User]) {
        viewController?.displayUsers(users)
    }
    
    func updateRequests(_ id: String) {
        viewController?.updateRequests(id)
    }
    
    func displayError(message: String) {
        viewController?.displayError(message: message)
    }
    
    func didNextStep(action: RequestsJoinGroupAction) {
        router.perform(action: action)
    }
}
