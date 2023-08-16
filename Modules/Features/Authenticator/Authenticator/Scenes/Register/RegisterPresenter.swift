protocol RegisterPresenting: AnyObject {
    func displaySomething()
    func didNextStep(action: RegisterAction)
}

final class RegisterPresenter {
    private let router: RegisterRouting
    weak var viewController: RegisterDisplaying?

    init(router: RegisterRouting) {
        self.router = router
    }
}

// MARK: - RegisterPresenting
extension RegisterPresenter: RegisterPresenting {
    func displaySomething() {
        viewController?.displayViewState(.error(message: ""))
    }
    
    func didNextStep(action: RegisterAction) {
        router.perform(action: action)
    }
}
