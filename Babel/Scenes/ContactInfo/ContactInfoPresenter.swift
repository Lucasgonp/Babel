protocol ContactInfoPresenterProtocol: AnyObject {
    func displayViewState(_ state: ContactInfoViewState)
    func didNextStep(action: ContactInfoAction)
}

final class ContactInfoPresenter {
    private let router: ContactInfoRouterProtocol
    weak var viewController: ContactInfoDisplaying?

    init(router: ContactInfoRouterProtocol) {
        self.router = router
    }
}

// MARK: - ContactInfoPresenterProtocol
extension ContactInfoPresenter: ContactInfoPresenterProtocol {
    func displayViewState(_ state: ContactInfoViewState) {
        viewController?.displayViewState(state)
    }
    
    func didNextStep(action: ContactInfoAction) {
        router.perform(action: action)
    }
}
