protocol TermsPresenterProtocol: AnyObject {
    func displaySomething()
    func didNextStep(action: TermsAction)
}

final class TermsPresenter {
    private let router: TermsRouterProtocol
    weak var viewController: TermsDisplaying?

    init(router: TermsRouterProtocol) {
        self.router = router
    }
}

// MARK: - TermsPresenterProtocol
extension TermsPresenter: TermsPresenterProtocol {
    func displaySomething() {
        viewController?.displaySomething()
    }
    
    func didNextStep(action: TermsAction) {
        router.perform(action: action)
    }
}
