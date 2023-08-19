import DesignKit

protocol LoginPresenting: AnyObject {
    func displayViewState(_ state: LoginViewState)
    func displayResendEmailAlert()
    func displayForgotPasswordAlert()
    func displayResetPasswordFeedback()
    func displayResentEmailFeedback()
    func didNextStep(action: LoginAction)
}

final class LoginPresenter {
    typealias Localizable = Strings.Login
    
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
    
    func displayResendEmailAlert() {
        let viewModel = AlertViewModel(
            title: Localizable.Alert.EmailVerification.Resend.title,
            message: Localizable.Alert.EmailVerification.Resend.message,
            firstButtonTitle: Localizable.Alert.EmailVerification.Resend.resendButton,
            secondButtonTitle: Strings.Alert.later
        )
        viewController?.displayResendEmail(viewModel: viewModel)
    }
    
    func displayForgotPasswordAlert() {
        let viewModel = AlertViewModel(
            title: Strings.ResetPassword.SendReset.title,
            message: Strings.ResetPassword.SendReset.message,
            firstButtonTitle: Strings.ResetPassword.SendReset.resetButton,
            secondButtonTitle: Strings.Alert.later,
            textFieldPlaceholder: Localizable.Field.Email.placeholder,
            textFieldKeyboardType: .emailAddress
        )
        viewController?.displayResetPassword(viewModel: viewModel)
    }
    
    func displayResentEmailFeedback() {
        let title = Localizable.Alert.EmailVerification.Resent.title
        let message = Localizable.Alert.EmailVerification.Resent.message
        viewController?.displayFeedbackAlert(title: title, message: message)
    }
    
    func displayResetPasswordFeedback() {
        let title = Strings.ResetPassword.SentReset.title
        let message = Strings.ResetPassword.SentReset.message
        viewController?.displayFeedbackAlert(title: title, message: message)
    }
    
    func didNextStep(action: LoginAction) {
        router.perform(action: action)
    }
}
