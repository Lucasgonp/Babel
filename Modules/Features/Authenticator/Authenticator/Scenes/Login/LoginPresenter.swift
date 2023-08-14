protocol LoginPresenting: AnyObject {
    func displaySomething()
    func didNextStep(action: LoginAction)
}

final class LoginPresenter {
    private let router: LoginRouting
    weak var viewController: LoginDisplaying?

    init(router: LoginRouting) {
        self.router = router
    }
}

// MARK: - LoginPresenting
extension LoginPresenter: LoginPresenting {
    func displaySomething() {
        viewController?.displaySomething()
    }
    
    func didNextStep(action: LoginAction) {
        router.perform(action: action)
    }
}
