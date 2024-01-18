import DesignKit

protocol LoginPresenterProtocol: AnyObject {
    func displayViewState(_ state: LoginViewState)
    func displayResendEmailAlert()
    func displayForgotPasswordAlert()
    func displayResetPasswordFeedback()
    func displayResentEmailFeedback()
    func didNextStep(action: LoginAction)
}

final class LoginPresenter {
    typealias Localizable = Strings.Login
    
    private let router: LoginRouterProtocol
    weak var viewController: LoginDisplaying?

    init(router: LoginRouterProtocol) {
        self.router = router
    }
}

// MARK: - LoginPresenterProtocol
extension LoginPresenter: LoginPresenterProtocol {
    func displayViewState(_ state: LoginViewState) {
        viewController?.displayViewState(state)
    }
    
    func displayResendEmailAlert() {
        let viewModel = AlertViewModel(
            title: Localizable.Alert.EmailVerification.Resend.title,
            message: Localizable.Alert.EmailVerification.Resend.message,
            firstButton: .init(title: Localizable.Alert.EmailVerification.Resend.resendButton, style: .cancel),
            secondButton: .init(title: Strings.Alert.later, style: .default)
        )
        viewController?.displayResendEmail(viewModel: viewModel)
    }
    
    func displayForgotPasswordAlert() {
        let viewModel = AlertViewModel(
            title: Strings.ResetPassword.SendReset.title,
            message: Strings.ResetPassword.SendReset.message,
            firstButton: .init(title: Strings.ResetPassword.SendReset.resetButton, style: .cancel),
            secondButton: .init(title: Strings.Alert.later, style: .default),
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
