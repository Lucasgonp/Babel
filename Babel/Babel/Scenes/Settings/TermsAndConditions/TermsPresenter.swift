protocol TermsPresenting: AnyObject {
    func displaySomething()
    func didNextStep(action: TermsAction)
}

final class TermsPresenter {
    private let router: TermsRouting
    weak var viewController: TermsDisplaying?

    init(router: TermsRouting) {
        self.router = router
    }
}

// MARK: - TermsPresenting
extension TermsPresenter: TermsPresenting {
    func displaySomething() {
        viewController?.displaySomething()
    }
    
    func didNextStep(action: TermsAction) {
        router.perform(action: action)
    }
}
