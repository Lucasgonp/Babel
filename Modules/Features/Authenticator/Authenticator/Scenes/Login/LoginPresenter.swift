protocol LoginPresenting: AnyObject {
    func displayViewState(_ state: LoginViewState)
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
    func displayViewState(_ state: LoginViewState) {
        viewController?.displayViewState(state)
    }
    
    func didNextStep(action: LoginAction) {
        router.perform(action: action)
    }
}
