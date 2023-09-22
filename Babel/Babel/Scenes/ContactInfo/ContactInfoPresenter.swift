protocol ContactInfoPresenting: AnyObject {
    func displayViewState(_ state: ContactInfoViewState)
    func didNextStep(action: ContactInfoAction)
}

final class ContactInfoPresenter {
    private let router: ContactInfoRouting
    weak var viewController: ContactInfoDisplaying?

    init(router: ContactInfoRouting) {
        self.router = router
    }
}

// MARK: - ContactInfoPresenting
extension ContactInfoPresenter: ContactInfoPresenting {
    func displayViewState(_ state: ContactInfoViewState) {
        viewController?.displayViewState(state)
    }
    
    func didNextStep(action: ContactInfoAction) {
        router.perform(action: action)
    }
}
