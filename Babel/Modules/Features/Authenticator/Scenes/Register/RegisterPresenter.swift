protocol RegisterPresenting: AnyObject {
    func displayViewState(_ state: RegisterViewState)
    func emailSentToNewUser()
    func didNextStep(action: RegisterAction)
}

final class RegisterPresenter {
    typealias Localizable = Strings.Register
    
    private let router: RegisterRouting
    weak var viewController: RegisterDisplaying?

    init(router: RegisterRouting) {
        self.router = router
    }
}

// MARK: - RegisterPresenting
extension RegisterPresenter: RegisterPresenting {
    func displayViewState(_ state: RegisterViewState) {
        viewController?.displayViewState(state)
    }
    
    func emailSentToNewUser() {
        let title = Localizable.Alert.EmailVerification.Verify.title
        let message = Localizable.Alert.EmailVerification.Verify.message
        router.popToLogin(title: title, message: message)
    }
    
    func didNextStep(action: RegisterAction) {
        router.perform(action: action)
    }
}
